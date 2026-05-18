if vim.g.loaded_gregorio_nvim then
  return
end

vim.g.loaded_gregorio_nvim = true

require("gregorio").setup()
