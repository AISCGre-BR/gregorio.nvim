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
}

local function merge_options(opts)
  return vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

local function setup_treesitter(opts)
  if not opts.treesitter.enabled then
    return
  end

  if vim.treesitter and vim.treesitter.language and vim.treesitter.language.register then
    pcall(vim.treesitter.language.register, opts.treesitter.language, "gabc")
  end

  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok then
    local parser_configs = parsers.get_parser_configs()
    if not parser_configs.gregorio then
      parser_configs.gregorio = {
        install_info = {
          url = "https://github.com/AISCGre-BR/tree-sitter-gregorio",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "gabc",
      }
    end
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

local function create_commands()
  vim.api.nvim_create_user_command("GabcTransposeUp", function(opts)
    commands.transpose_up(opts)
  end, { range = true, desc = "Transpose GABC notes up" })

  vim.api.nvim_create_user_command("GabcTransposeDown", function(opts)
    commands.transpose_down(opts)
  end, { range = true, desc = "Transpose GABC notes down" })

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
  create_commands()
end

return M
