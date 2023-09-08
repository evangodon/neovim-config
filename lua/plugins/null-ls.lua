-- Null-LS
-- https://github.com/jose-elias-alvarez/null-ls.nvim

local M = {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPre",
  enabled = true,
}

function M.config()
  local null_ls = require "null-ls"

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

  -- local augroup = vim.api.nvim_create_augroup("null-ls-Formatting", {})

  null_ls.setup({
    debug = false,
    sources = {
      -- JS
      formatting.prettier,
      -- formatting.eslint_d,

      -- Lua
      formatting.stylua,
    },
  })
end

return M
