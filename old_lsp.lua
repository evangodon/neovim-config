local M = {
  "VonHeikemen/lsp-zero.nvim",
  enabled = false,
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
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
    "williamboman/mason-lspconfig.nvim",
  },
  event = "BufReadPre",
}

local server = {
  ts = "ts_ls",
  deno = "denols",
  lua = "lua_ls",
  eslint = "eslint",
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
  local lsp_zero = require "lsp-zero"
  local format = require "lsp/format"
  local telescope_pickers = require "telescope.builtin"
  local telescope_theme = require "telescope.themes"
  local lspconfig = require "lspconfig"

  local install_servers = {}
  for _, v in pairs(server) do
    table.insert(install_servers, v)
  end

  lsp_zero.ensure_installed(install_servers)

  lsp_zero.set_preferences({
    manage_nvim_cmp = false, -- managed in ./cmp.lua
    suggest_lsp_servers = true,
    cmp_capabilities = false,
  })

  -- LSP server configurations
  lsp_zero.configure(server.lua, require "user.lsp.settings.luals")
  lsp_zero.configure(server.json, require "user.lsp.settings.jsonls")
  lsp_zero.configure(server.ts, {
    root_dir = lspconfig.util.root_pattern ".git",
    single_file_support = false,
    init_options = {
      lint = false,
      format = false,
    },
  })
  lsp_zero.configure(server.deno, {
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.lock"),
    init_options = {
      lint = false,
    },
  })
  --[[ lspconfig.eslint.setup({ ]]
  --[[   root_dir = lspconfig.util.root_pattern(".eslintrc.json", ".eslintrc.js", "package.json", "tsconfig.json", ".git"), ]]
  --[[   settings = { ]]
  --[[     format = false, ]]
  --[[   }, ]]
  --[[ }) ]]
  lsp_zero.configure(server.yaml, {
    settings = {
      yaml = {
        keyOrdering = false,
      },
    },
  })

  local telescope_ivy_theme = telescope_theme.get_ivy({
    layout_config = { height = 0.5 },
    initial_mode = "normal",
    preview_title = "Preview",
    show_line = true,
  })

  -- Keymaps
  lsp_zero.on_attach(function(client, bufnr)
    -- Handle tsserver and denols
    if lspconfig.util.root_pattern "deno.json"(vim.fn.getcwd()) then
      if client.name == server.ts then
        client.stop()
        return
      end
    end

    -- KEYMAPS
    local function setBufOpts(desc)
      return { noremap = true, silent = true, buffer = bufnr, desc = desc }
    end

    local keymap = vim.keymap.set

    keymap("n", "gD", vim.lsp.buf.declaration, setBufOpts "Jump to declaration")
    keymap("n", "gd", vim.lsp.buf.definition, setBufOpts "Jump to definition")
    keymap("n", "gh", vim.lsp.buf.hover, setBufOpts "Hover")
    keymap("n", "gI", vim.lsp.buf.implementation, setBufOpts "Implementation")
    keymap("n", "gi", function()
      telescope_pickers.lsp_implementations(telescope_ivy_theme)
    end, setBufOpts "Implementation")
    keymap("n", "<C-k>", vim.lsp.buf.signature_help, setBufOpts "Signature help")
    keymap("n", "gr", function()
      telescope_pickers.lsp_references(telescope_ivy_theme)
    end, setBufOpts "Find references")
    keymap("n", "<F2>", vim.lsp.buf.rename, setBufOpts "Rename")
    keymap("n", "[d", function()
      vim.diagnostic.goto_prev({ border = "single" })
    end, setBufOpts "Jump to previous diagnostic")
    keymap("n", "gl", function()
      vim.diagnostic.open_float({ border = "single" })
    end, setBufOpts "Open diagnostics")
    keymap("n", "]d", function()
      vim.diagnostic.goto_next({ border = "single" })
    end, setBufOpts "Jump to next diagnostic")

    -- FORMAT ON SAVE
    format.setup()
  end)

  lsp_zero.setup()
  require("lspconfig.ui.windows").default_options.border = "single"
end

return M
