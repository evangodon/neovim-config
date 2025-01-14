local M = {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    { "williamboman/mason.nvim" },
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
    {
      "williamboman/mason.nvim",
      lazy = false,
      opts = {},
    },
  },
}

local lsp_server = {
  ts = "ts_ls",
  deno = "denols",
  lua = "lua_ls",
  --eslint = "eslint",
  go = "gopls",
  json = "jsonls",
  yaml = "yamlls",
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

local custom_signs = {
  Error = "󰯈",
  Warn = "󱙝",
  Hint = "",
  Info = "󰮯",
}

for type, icon in pairs(custom_signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

function M.config()
  local lspconfig = require "lspconfig"
  local mason = require "mason-lspconfig"
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  -- Styling
  --require("lspconfig.ui.windows").default_options.border = "single"

  local ensure_installed = {}
  for _, value in pairs(lsp_server) do
    table.insert(ensure_installed, value)
  end

  mason.setup({
    ensure_installed = ensure_installed,
    handlers = {
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
        })
      end,
      -- Go
      [lsp_server.go] = function()
        lspconfig.gopls.setup({})
      end,
      -- Deno
      [lsp_server.deno] = function()
        lspconfig.denols.setup({
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        })
      end,
      -- Typescript
      [lsp_server.ts] = function()
        lspconfig[lsp_server.ts].setup({
          root_dir = lspconfig.util.root_pattern "package.json",
          single_file_support = false,
        })
      end,
      -- Lua
      [lsp_server.lua] = function()
        lspconfig[lsp_server.lua].setup(require "lsp.luals")
      end,
      -- Yaml
      [lsp_server.yaml] = function()
        lspconfig[lsp_server.yaml].setup({
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        })
      end,
    },
  })
end

return M
