vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.gabc",
  callback = function(args)
    vim.bo[args.buf].filetype = "gabc"
  end,
})
