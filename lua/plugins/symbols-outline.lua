local M = {
  "simrat39/symbols-outline.nvim",
  event = "BufReadPre",
}

function M.config()
  require("symbols-outline").setup({
    width = 25,
    relative_width = true,
  })
end

function M.init()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf or vim.api.nvim_get_current_buf()
      vim.keymap.set("n", "<leader>S", Cmd "SymbolsOutline", {
        buffer = bufnr,
        desc = "Toggle Symbols Outline",
      })
    end,
  })
end

return M
