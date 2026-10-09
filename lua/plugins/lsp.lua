local M = {
  "neovim/nvim-lspconfig",
  lazy = false,
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    { "williamboman/mason-lspconfig.nvim" },
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup({
          ui = {
            border = "single",
          },
        })
      end,
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
}

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰯈",
      [vim.diagnostic.severity.WARN] = "󱙝",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "»",
    },
  },
})

local lsp_server = {
  ts = "ts_ls",
  deno = "denols",
  lua = "lua_ls",
  eslint = "eslint",
  go = "gopls",
  json = "jsonls",
  ruby = "ruby_lsp",
}

function M.config()
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  vim.lsp.config["*"] = {
    capabilities = capabilities,
  }

  require "lsp.luals"

  local ensure_installed = {}
  for _, value in pairs(lsp_server) do
    table.insert(ensure_installed, value)
  end

  local mason_lspconfig = require "mason-lspconfig"

  mason_lspconfig.setup({
    automatic_enable = {
      exclude = { lsp_server.deno },
    },
    ensure_installed = ensure_installed,
  })
end

return M
