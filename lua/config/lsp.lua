local floating_window = require "util.floating_window"
local icons = require "util.icons"

local group = vim.api.nvim_create_augroup("config_lsp", { clear = true })
local logger = vim.log.new({ name = "nvim-2027", level = vim.log.levels.TRACE })

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.default,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.default,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.default,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.default,
    },
  },
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 2 },
  severity_sort = true,
  float = { border = "rounded" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    vim.keymap.set(
      "n",
      "gD",
      vim.lsp.buf.declaration,
      vim.tbl_extend("force", opts, {
        desc = "Jump to declaration",
      })
    )
    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      vim.tbl_extend("force", opts, {
        desc = "Jump to definition",
      })
    )
    vim.keymap.set("n", "gh", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, vim.tbl_extend("force", opts, { desc = "Hover" }))
    vim.keymap.set(
      "n",
      "gI",
      vim.lsp.buf.implementation,
      vim.tbl_extend("force", opts, {
        desc = "Implementation",
      })
    )
    vim.keymap.set("n", "gi", function()
      require("telescope.builtin").lsp_implementations(require("telescope.themes").get_ivy({
        layout_config = { height = 0.5 },
        initial_mode = "normal",
        preview_title = "Preview",
        show_line = true,
      }))
    end, vim.tbl_extend("force", opts, { desc = "Implementation" }))
    vim.keymap.set(
      "n",
      "grt",
      vim.lsp.buf.type_definition,
      vim.tbl_extend("force", opts, {
        desc = "Type definition",
      })
    )
    vim.keymap.set(
      "n",
      "gO",
      vim.lsp.buf.document_symbol,
      vim.tbl_extend("force", opts, {
        desc = "Document symbols",
      })
    )
    vim.keymap.set(
      "n",
      "gra",
      vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, {
        desc = "Code actions",
      })
    )
    vim.keymap.set(
      "n",
      "K",
      function()
        vim.lsp.buf.signature_help({ border = "rounded" })
      end,
      vim.tbl_extend("force", opts, {
        desc = "Signature help",
      })
    )
    vim.keymap.set("n", "gr", function()
      require("telescope.builtin").lsp_references(require("telescope.themes").get_ivy({
        layout_config = { height = 0.5 },
        initial_mode = "normal",
        preview_title = "Preview",
        show_line = true,
      }))
    end, vim.tbl_extend("force", opts, { desc = "Find references" }))
    vim.keymap.set("n", "R", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
    vim.keymap.set("n", "[d", function()
      if vim.diagnostic.jump({ count = -1 }) then
        vim.diagnostic.open_float({ border = "single" })
      end
    end, vim.tbl_extend("force", opts, { desc = "Jump to previous diagnostic" }))
    vim.keymap.set("n", "gl", function()
      vim.diagnostic.open_float({ border = "single" })
    end, vim.tbl_extend("force", opts, { desc = "Open diagnostics" }))
    vim.keymap.set("n", "]d", function()
      if vim.diagnostic.jump({ count = 1 }) then
        vim.diagnostic.open_float({ border = "single" })
      end
    end, vim.tbl_extend("force", opts, { desc = "Jump to next diagnostic" }))
  end,
})

local servers = {
  { name = "lua_ls", executable = "lua-language-server" },
  { name = "ts_ls", executable = "typescript-language-server" },
  { name = "bun_ts", executable = "bunx" },
  { name = "denols", executable = "deno" },
  { name = "eslint", executable = "vscode-eslint-language-server" },
  { name = "gopls", executable = "gopls" },
  { name = "jsonls", executable = "vscode-json-language-server" },
  { name = "ruby_lsp", executable = "ruby-lsp" },
}

local enabled_servers = {}

vim.api.nvim_create_user_command("LspStatus", function()
  local buffer = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  local configs = vim.lsp.get_configs({ enabled = true, filetype = vim.bo[buffer].filetype })
  local lines = {
    "LSP status",
    "Buffer: " .. vim.api.nvim_buf_get_name(buffer),
    "Filetype: " .. vim.bo[buffer].filetype,
    "",
    "Attached clients:",
  }

  if #clients == 0 then
    table.insert(lines, "  none")
  else
    for _, client in ipairs(clients) do
      local command = client.config.cmd
      local command_text = type(command) == "table" and table.concat(command, " ") or "dynamic command"
      table.insert(lines, ("  %s"):format(client.name))
      table.insert(lines, ("    command: %s"):format(command_text))
      table.insert(lines, ("    root: %s"):format(client.root_dir or "none"))
    end
  end

  table.insert(lines, "")
  table.insert(lines, "Enabled matching configs:")
  if #configs == 0 then
    table.insert(lines, "  none")
  else
    for _, config in ipairs(configs) do
      local command = config.cmd
      local command_text = type(command) == "table" and table.concat(command, " ") or "dynamic command"
      table.insert(lines, ("  %s"):format(config.name))
      table.insert(lines, ("    command: %s"):format(command_text))
    end
  end

  local highlights = {}
  for line, text in ipairs(lines) do
    local highlight_group = line == 1 and "Title" or (text:match "^%S.*:$" and "DiagnosticInfo" or nil)
    if highlight_group then
      table.insert(highlights, { group = highlight_group, line = line - 1, start = 0, finish = -1 })
    end
  end

  floating_window.show_lines(lines, "LSP status", highlights)
end, { desc = "Show native LSP status" })

---@param filetype string
local function enable_servers_for(filetype)
  for _, server in ipairs(servers) do
    local config = vim.lsp.config[server.name]
    if not enabled_servers[server.name] and config and vim.tbl_contains(config.filetypes or {}, filetype) then
      enabled_servers[server.name] = true
      if vim.fn.executable(server.executable) == 1 then
        vim.lsp.enable(server.name)
      else
        logger.debug(("LSP server unavailable: %s (%s)"):format(server.name, server.executable))
      end
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    enable_servers_for(vim.bo[args.buf].filetype)
  end,
})
