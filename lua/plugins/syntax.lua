-- Treesitter parsers are installed by the plugin; Neovim owns highlighting and indentation.

local notify = require "util.notify"

local parsers = {
  "markdown",
  "markdown_inline",
  "fish",
  "lua",
  "html",
  "css",
  "javascript",
  "typescript",
  "tsx",
  "go",
  "ruby",
  "sql",
  "hurl",
}

local M = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
}

---@return nil
function M.config()
  local treesitter = require "nvim-treesitter"

  treesitter.setup({})

  -- Skip parser installation when the CLI is absent instead of failing on startup.
  if vim.fn.executable "tree-sitter" == 1 then
    treesitter.install(parsers)
  else
    notify.warn "tree-sitter CLI not found, parsers cannot be installed"
  end

  vim.g.markdown_fenced_languages = { "html", "python", "lua", "vim", "typescript", "javascript", "sql" }
end

return M
