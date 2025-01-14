--- https://github.com/stevearc/conform.nvim
local M = {
  "stevearc/conform.nvim",
  event = "BufReadPre",
}

function M.config()
  local conform = require "conform"

  local prettier_fmt = { "prettierd", "prettier", stop_after_first = true }

  vim.g.enable_format_on_save = true

  local function toggle_autoformat()
    vim.g.enable_format_on_save = not vim.g.enable_format_on_save
    Notify.info("Autoformat " .. (vim.g.enable_format_on_save and "enabled" or "disabled"))
  end

  vim.keymap.set("n", LeaderKey "Tf", function()
    toggle_autoformat()
  end, { desc = "Toggle format on save" })

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
    format_on_save = function()
      if not vim.g.enable_format_on_save then
        return
      end

      return {
        timeout_ms = 500,
        lsp_format = "fallback",
      }
    end,
  })
end

function M.init()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      P("ENABLED" .. vim.g.enable_format_on_save)
      if vim.g.enable_format_on_save then
        require("conform").format({ bufnr = args.buf })
      end
    end,
  })
end

return M
