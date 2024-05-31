local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set(
  "n", 
  "<leader>a", 
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = bufnr,
  callback = function()
    vim.lsp.buf.format { async = false }
  end
})
