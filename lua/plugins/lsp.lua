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

local icon = require "user.icons"

local custom_signs = {
  Error = "󰯈",
  Warn = "󱙝",
  Hint = icon.diagnostics.default,
  Info = "󰮯",
}

for type, icon in pairs(custom_signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local lsp_server = {
  ts = "ts_ls",
  deno = "denols",
  lua = "lua_ls",
  eslint = "eslint",
  go = "gopls",
  json = "jsonls",
  yaml = "yamlls",
}

function M.config()
  local lspconfig = require "lspconfig"
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  vim.lsp.config["*"] = {
    capabilities = capabilities,
    on_attach = function() end,
  }

  vim.lsp.config[lsp_server.ts] = {
    --single_file_support = false,
  }

  vim.lsp.config[lsp_server.deno] = {
    --root_dir = lspconfig.util.root_pattern "deno.json",
  }

  require "lsp.luals"

  vim.lsp.config[lsp_server.yaml] = {
    settings = {
      yaml = {
        keyOrdering = false,
      },
    },
  }

  -- Styling
  --require("lspconfig.ui.windows").default_options.border = "single"

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
