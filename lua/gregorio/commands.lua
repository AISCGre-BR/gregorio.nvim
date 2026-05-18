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

local function find_separator_line(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for idx, line in ipairs(lines) do
    if line:match("^%%+%s*$") then
      return idx
    end
  end

  return 0
end

local function line_range(line1, line2)
  local first = math.max((line1 or 1) - 1, 0)
  local last = math.max((line2 or line1 or 1) - 1, first)
  return first, last
end

local function transpose_line(line, direction)
  local out = {}
  local in_parens = false
  local in_brackets = false

  for index = 1, #line do
    local char = line:sub(index, index)

    if char == "(" then
      in_parens = true
      in_brackets = false
      out[#out + 1] = char
    elseif char == ")" then
      in_parens = false
      in_brackets = false
      out[#out + 1] = char
    elseif in_parens and char == "[" then
      in_brackets = true
      out[#out + 1] = char
    elseif in_parens and char == "]" then
      in_brackets = false
      out[#out + 1] = char
    elseif in_parens and not in_brackets and char:match("[A-Ma-mnp]") then
      out[#out + 1] = transpose_note(char, direction)
    else
      out[#out + 1] = char
    end
  end

  return table.concat(out)
end

local function apply_on_range(transform, opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local separator = find_separator_line(bufnr)
  local start_line, end_line = line_range(opts.line1, opts.line2)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)

  for i, line in ipairs(lines) do
    local absolute = start_line + i
    if absolute > separator then
      lines[i] = transform(line)
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, start_line, end_line + 1, false, lines)
end

local function apply_on_body(transform)
  local bufnr = vim.api.nvim_get_current_buf()
  local separator = find_separator_line(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    if i > separator then
      lines[i] = transform(line)
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

function M.transpose_up(opts)
  apply_on_range(function(line)
    return transpose_line(line, 1)
  end, opts)
end

function M.transpose_down(opts)
  apply_on_range(function(line)
    return transpose_line(line, -1)
  end, opts)
end

function M.fill_parens(opts)
  apply_on_range(function(line)
    return line:gsub("%(%s*%)", "(f)")
  end, opts)
end

function M.convert_ligatures_to_tags()
  apply_on_body(function(line)
    line = line:gsub("æ", "<sp>ae</sp>")
    line = line:gsub("ǽ", "<sp>'ae</sp>")
    line = line:gsub("œ", "<sp>oe</sp>")
    return line
  end)
end

function M.convert_tags_to_ligatures()
  apply_on_body(function(line)
    line = line:gsub("<sp>ae</sp>", "æ")
    line = line:gsub("<sp>'ae</sp>", "ǽ")
    line = line:gsub("<sp>oe</sp>", "œ")
    return line
  end)
end

return M
