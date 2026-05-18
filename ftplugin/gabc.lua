local has_treesitter = false

if vim.treesitter and vim.treesitter.get_parser then
  local ok = pcall(vim.treesitter.get_parser, 0, "gregorio")
  has_treesitter = ok
end

if not has_treesitter then
  vim.bo.syntax = "gabc"
end

vim.opt_local.commentstring = "% %s"
vim.opt_local.formatoptions:remove({ "r", "o", "c" })
