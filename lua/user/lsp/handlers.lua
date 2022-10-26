local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "•" },
    { name = "DiagnosticSignWarn", text = "•" },
    { name = "DiagnosticSignHint", text = "•" },
    { name = "DiagnosticSignInfo", text = "•" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "none",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
  })

  -- Don't show diagnostics in insert mode
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = false,
  })
end

local function lsp_keymaps(bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  local function setBufOpts(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
  end

  local keymap = vim.keymap.set

  keymap("n", "gD", vim.lsp.buf.declaration, setBufOpts "Jump to declaration")
  keymap("n", "gd", vim.lsp.buf.definition, setBufOpts "Jump to definition")
  keymap("n", "gh", vim.lsp.buf.hover, setBufOpts "Hover")
  keymap("n", "gi", vim.lsp.buf.implementation, setBufOpts "Implementation")
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
  keymap("n", "<leader>f", vim.lsp.buf.formatting, setBufOpts "Format document")

  vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.formatting()
  end, {})
end

M.on_attach = function(_, bufnr)
  lsp_keymaps(bufnr)
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  Notify.error "cmp_nvim_lsp not found"
  return
end

M.capabilities = cmp_nvim_lsp.default_capabilities()

return M
