local M = {}

local notes = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "p" }
local note_to_index = {}

for index, note in ipairs(notes) do
  note_to_index[note] = index
end

local function transpose_note(letter, direction)
  local lower = letter:lower()
  local current = note_to_index[lower]
  if not current then
    return letter
  end

  local next_index = current + direction
  if next_index < 1 then
    next_index = #notes
  elseif next_index > #notes then
    next_index = 1
  end

  local next_note = notes[next_index]
  if letter:match("%u") then
    return next_note:upper()
  end

  return next_note
end

-- Returns the 1-indexed line number of the %% header/body separator, or 0 if absent.
-- This value doubles as the 0-indexed position of the first body line for nvim_buf_get_lines.
local function find_separator_line(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for idx, line in ipairs(lines) do
    if line:match("^%%+%s*$") then
      return idx
    end
  end
  return 0
end

-- Reads the nabc-lines header value; returns 0 when the header is absent.
local function get_nabc_lines(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match("^%%+%s*$") then
      break
    end
    local n = line:match("^nabc%-lines%s*:%s*(%d+)")
    if n then
      return tonumber(n)
    end
  end
  return 0
end

local function line_range(line1, line2)
  local first = math.max((line1 or 1) - 1, 0)
  local last = math.max((line2 or line1 or 1) - 1, first)
  return first, last
end

-- Transposes note letters inside GABC note groups.
-- With nabc_lines > 0, only GABC segments are transposed: in a group (s0|s1|...|sN),
-- segment at index i is GABC when i % (nabc_lines + 1) == 0.
-- Accidentals (x, y, #) and custos (+) following a note letter are preserved as-is
-- because they are not note letters and simply pass through unchanged.
local function transpose_line(line, direction, nabc_lines)
  nabc_lines = nabc_lines or 0
  local out = {}
  local in_parens = false
  local in_brackets = false
  local segment_index = 0

  for i = 1, #line do
    local char = line:sub(i, i)

    if char == "(" then
      in_parens = true
      in_brackets = false
      segment_index = 0
      out[#out + 1] = char
    elseif char == ")" then
      in_parens = false
      in_brackets = false
      out[#out + 1] = char
    elseif in_parens and not in_brackets and char == "|" then
      segment_index = segment_index + 1
      out[#out + 1] = char
    elseif in_parens and char == "[" then
      in_brackets = true
      out[#out + 1] = char
    elseif in_parens and char == "]" then
      in_brackets = false
      out[#out + 1] = char
    elseif in_parens and not in_brackets and char:match("[A-Ma-mnp]") then
      local is_gabc = nabc_lines == 0 or (segment_index % (nabc_lines + 1) == 0)
      if is_gabc then
        out[#out + 1] = transpose_note(char, direction)
      else
        out[#out + 1] = char
      end
    else
      out[#out + 1] = char
    end
  end

  return table.concat(out)
end

-- Returns the last GABC note letter found in a group's content string.
-- Only looks at the GABC segment (before the first |) and ignores [...] blocks.
local function last_gabc_pitch(group_content)
  local gabc = group_content:match("^([^|]*)") or group_content
  local last = nil
  local in_brackets = false
  for i = 1, #gabc do
    local c = gabc:sub(i, i)
    if c == "[" then
      in_brackets = true
    elseif c == "]" then
      in_brackets = false
    elseif not in_brackets and c:match("[A-Ma-mnp]") then
      last = c
    end
  end
  return last
end

-- Fills empty note groups with the last pitch of the preceding non-empty group.
-- Example: (fgh) () () (ij) () -> (fgh) (h) (h) (ij) (j) (j)
-- Operates on a multi-line text block, preserving cross-line state.
local function fill_parens_block(text)
  local last_pitch = nil
  local result = {}
  local i = 1

  while i <= #text do
    local char = text:sub(i, i)
    if char == "(" then
      local j = text:find(")", i, true)
      if not j then
        result[#result + 1] = text:sub(i)
        break
      end
      local content = text:sub(i + 1, j - 1)
      if content:match("^%s*$") then
        result[#result + 1] = last_pitch and ("(" .. last_pitch .. ")") or text:sub(i, j)
      else
        result[#result + 1] = text:sub(i, j)
        local pitch = last_gabc_pitch(content)
        if pitch then
          last_pitch = pitch
        end
      end
      i = j + 1
    else
      result[#result + 1] = char
      i = i + 1
    end
  end

  return table.concat(result)
end

-- Applies a block transform to only the body lines of the selected range,
-- clamping the start to the first body line when the range covers the header.
-- For character-wise single-line selection ('v'), restricts the transform to
-- the selected columns rather than the whole line.
local function apply_on_range(transform, opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local separator = find_separator_line(bufnr)
  local start_line, end_line = line_range(opts.line1, opts.line2)
  local effective_start = math.max(start_line, separator)
  if effective_start > end_line then
    return
  end

  if vim.fn.visualmode() == "v" and effective_start == end_line then
    local spos = vim.fn.getpos("'<")
    local epos = vim.fn.getpos("'>")
    -- Only use column info when the marks match the command's range
    -- (avoids false positives from stale marks after a command-line range).
    if spos[2] - 1 == effective_start and epos[2] - 1 == end_line then
      local scol = spos[3] -- 1-indexed, inclusive start column
      local ecol = epos[3] -- 1-indexed, inclusive end column (may be large for EOL)
      local line =
        vim.api.nvim_buf_get_lines(bufnr, effective_start, effective_start + 1, false)[1] or ""
      local e = math.min(ecol, #line)
      local new_line = line:sub(1, scol - 1) .. transform(line:sub(scol, e)) .. line:sub(e + 1)
      vim.api.nvim_buf_set_lines(bufnr, effective_start, effective_start + 1, false, { new_line })
      return
    end
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, effective_start, end_line + 1, false)
  local text = table.concat(lines, "\n")
  local new_text = transform(text)
  local new_lines = vim.split(new_text, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, effective_start, end_line + 1, false, new_lines)
end

-- Applies a block transform to the entire chant body (all lines after %%).
local function apply_on_body(transform)
  local bufnr = vim.api.nvim_get_current_buf()
  local separator = find_separator_line(bufnr)
  local total = vim.api.nvim_buf_line_count(bufnr)
  if separator >= total then
    return
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, separator, total, false)
  local text = table.concat(lines, "\n")
  local new_text = transform(text)
  local new_lines = vim.split(new_text, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, separator, total, false, new_lines)
end

local function make_transpose_transform(direction, nabc_lines)
  return function(text)
    local lines = vim.split(text, "\n", { plain = true })
    for i, line in ipairs(lines) do
      lines[i] = transpose_line(line, direction, nabc_lines)
    end
    return table.concat(lines, "\n")
  end
end

function M.transpose_up(opts)
  local nabc_lines = get_nabc_lines(vim.api.nvim_get_current_buf())
  local transform = make_transpose_transform(1, nabc_lines)
  if opts.range == 0 then
    apply_on_body(transform)
  else
    apply_on_range(transform, opts)
  end
end

function M.transpose_down(opts)
  local nabc_lines = get_nabc_lines(vim.api.nvim_get_current_buf())
  local transform = make_transpose_transform(-1, nabc_lines)
  if opts.range == 0 then
    apply_on_body(transform)
  else
    apply_on_range(transform, opts)
  end
end

function M.fill_parens(opts)
  if opts.range == 0 then
    apply_on_body(fill_parens_block)
  else
    apply_on_range(fill_parens_block, opts)
  end
end

function M.convert_ligatures_to_tags()
  apply_on_body(function(text)
    text = text:gsub("æ", "<sp>ae</sp>")
    text = text:gsub("ǽ", "<sp>'ae</sp>")
    text = text:gsub("œ", "<sp>oe</sp>")
    return text
  end)
end

function M.convert_tags_to_ligatures()
  apply_on_body(function(text)
    text = text:gsub("<sp>ae</sp>", "æ")
    text = text:gsub("<sp>'ae</sp>", "ǽ")
    text = text:gsub("<sp>oe</sp>", "œ")
    return text
  end)
end

return M
