local commands = require("gregorio.commands")

local M = {}

local defaults = {
  lsp = {
    enabled = true,
    cmd = { "gregorio-lsp" },
  },
  treesitter = {
    enabled = true,
    language = "gregorio",
  },
  keymaps = {
    enabled = true,
    note_shift_up = "<LocalLeader>su",
    note_shift_down = "<LocalLeader>sd",
    fill_parens = "<LocalLeader>fp",
    convert_ligatures_to_tags = "<LocalLeader>lt",
    convert_tags_to_ligatures = "<LocalLeader>tl",
  },
}

local function merge_options(opts)
  local user_keymaps = (opts or {}).keymaps or {}
  local options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
  local keymaps = options.keymaps or {}

  if user_keymaps.note_shift_up == nil and user_keymaps.transpose_up ~= nil then
    keymaps.note_shift_up = user_keymaps.transpose_up
  end

  if user_keymaps.note_shift_down == nil and user_keymaps.transpose_down ~= nil then
    keymaps.note_shift_down = user_keymaps.transpose_down
  end

  keymaps.transpose_up = nil
  keymaps.transpose_down = nil

  return options
end

local function setup_treesitter(opts)
  if not opts.treesitter.enabled then
    return
  end

  if vim.treesitter and vim.treesitter.language and vim.treesitter.language.register then
    pcall(vim.treesitter.language.register, opts.treesitter.language, "gabc")
  end
end

local function setup_lsp(opts)
  if not opts.lsp.enabled then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("gregorio_lsp", { clear = true }),
    pattern = "gabc",
    callback = function(args)
      if vim.fn.executable(opts.lsp.cmd[1]) == 0 then
        return
      end

      if vim.lsp.start then
        vim.lsp.start({
          name = "gregorio-lsp",
          cmd = opts.lsp.cmd,
          root_dir = vim.fs.root(args.buf, { ".git" }) or vim.loop.cwd(),
        })
      end
    end,
  })
end

local function setup_keymaps(opts)
  if not opts.keymaps.enabled then
    return
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("gregorio_keymaps", { clear = true }),
    pattern = "gabc",
    callback = function(args)
      local buf = args.buf
      local km = opts.keymaps

      if km.note_shift_up then
        vim.keymap.set("n", km.note_shift_up, "<cmd>GabcNoteShiftUp<CR>",
          { buffer = buf, desc = "Shift GABC notes up", silent = true })
        vim.keymap.set("x", km.note_shift_up, ":GabcNoteShiftUp<CR>",
          { buffer = buf, desc = "Shift GABC notes up", silent = true })
      end

      if km.note_shift_down then
        vim.keymap.set("n", km.note_shift_down, "<cmd>GabcNoteShiftDown<CR>",
          { buffer = buf, desc = "Shift GABC notes down", silent = true })
        vim.keymap.set("x", km.note_shift_down, ":GabcNoteShiftDown<CR>",
          { buffer = buf, desc = "Shift GABC notes down", silent = true })
      end

      if km.fill_parens then
        vim.keymap.set("n", km.fill_parens, "<cmd>GabcFillParens<CR>",
          { buffer = buf, desc = "Fill empty GABC note groups", silent = true })
        vim.keymap.set("x", km.fill_parens, ":GabcFillParens<CR>",
          { buffer = buf, desc = "Fill empty GABC note groups", silent = true })
      end

      if km.convert_ligatures_to_tags then
        vim.keymap.set("n", km.convert_ligatures_to_tags, "<cmd>GabcConvertLigaturesToTags<CR>",
          { buffer = buf, desc = "Convert ligatures to <sp> tags", silent = true })
      end

      if km.convert_tags_to_ligatures then
        vim.keymap.set("n", km.convert_tags_to_ligatures, "<cmd>GabcConvertTagsToLigatures<CR>",
          { buffer = buf, desc = "Convert <sp> tags to ligatures", silent = true })
      end
    end,
  })
end

local function create_commands()
  vim.api.nvim_create_user_command("GabcNoteShiftUp", function(opts)
    commands.note_shift_up(opts)
  end, { range = true, desc = "Shift GABC notes up" })

  vim.api.nvim_create_user_command("GabcNoteShiftDown", function(opts)
    commands.note_shift_down(opts)
  end, { range = true, desc = "Shift GABC notes down" })

  vim.api.nvim_create_user_command("GabcTransposeUp", function(opts)
    commands.note_shift_up(opts)
  end, { range = true, desc = "Deprecated alias for GabcNoteShiftUp" })

  vim.api.nvim_create_user_command("GabcTransposeDown", function(opts)
    commands.note_shift_down(opts)
  end, { range = true, desc = "Deprecated alias for GabcNoteShiftDown" })

  vim.api.nvim_create_user_command("GabcFillParens", function(opts)
    commands.fill_parens(opts)
  end, { range = true, desc = "Fill empty GABC note groups" })

  vim.api.nvim_create_user_command("GabcConvertLigaturesToTags", function()
    commands.convert_ligatures_to_tags()
  end, { desc = "Convert ligatures to <sp> tags in GABC body" })

  vim.api.nvim_create_user_command("GabcConvertTagsToLigatures", function()
    commands.convert_tags_to_ligatures()
  end, { desc = "Convert <sp> tags to ligatures in GABC body" })
end

function M.setup(opts)
  local options = merge_options(opts)
  setup_treesitter(options)
  setup_lsp(options)
  setup_keymaps(options)
  create_commands()
end

return M
