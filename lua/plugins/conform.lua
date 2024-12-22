--- https://github.com/stevearc/conform.nvim
local M = {
  "stevearc/conform.nvim",
}

function M.config()
  local conform = require "conform"

  local prettier_fmt = { "prettierd", "prettier", stop_after_first = true }

  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
      go = { "gofmt" },
      javascript = prettier_fmt,
      typescript = prettier_fmt,
      javascriptreact = prettier_fmt,
      typescriptreact = prettier_fmt,
      json = prettier_fmt,
      yaml = prettier_fmt,
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  })
end

function M.init()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format({ bufnr = args.buf })
    end,
  })
end

return M
