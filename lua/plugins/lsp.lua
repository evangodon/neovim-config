local M = {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
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
    "williamboman/mason-lspconfig.nvim",
  },
  event = "BufReadPre",
}

local function format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  })
end

function M.config()
  local lsp = require "lsp-zero"

  lsp.preset "recommended"

  lsp.ensure_installed({
    "denols",
    "eslint",
    "sumneko_lua",
    "gopls",
    "jsonls",
  })

  lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
      error = "•",
      warn = "•",
      hint = "•",
      info = "•",
    },
  })

  vim.diagnostic.config({
    virtual_text = true,
  })

  -- LSP server configurations
  local lspconfig = require "lspconfig"
  lsp.configure("sumneko_lua", require "user.lsp.settings.sumneko_lua")
  lsp.configure("jsonls", require "user.lsp.settings.jsonls")
  lsp.configure("tsserver", {
    root_dir = lspconfig.util.root_pattern "package.json",
    init_options = {
      lint = false,
    },
  })
  lsp.configure("denols", {
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    init_options = {
      lint = false,
    },
  })

  -- Keymaps
  lsp.on_attach(function(client, bufnr)
    local function setBufOpts(desc)
      return { noremap = true, silent = true, buffer = bufnr, desc = desc }
    end

    local keymap = vim.keymap.set

    keymap("n", "gD", vim.lsp.buf.declaration, setBufOpts "Jump to declaration")
    keymap("n", "gd", vim.lsp.buf.definition, setBufOpts "Jump to definition")
    keymap("n", "gh", vim.lsp.buf.hover, setBufOpts "Hover")
    --keymap("n", "gI", vim.lsp.buf.implementation, setBufOpts "Implementation")
    keymap("n", "<C-k>", vim.lsp.buf.signature_help, setBufOpts "Signature help")
    keymap("n", "gr", vim.lsp.buf.references, setBufOpts "Find references")
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

    -- Format on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          format()
        end,
      })
    end
  end)

  lsp.setup({})
  require("lspconfig.ui.windows").default_options.border = "single"
end

return M
