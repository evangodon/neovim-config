local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
}

function M.config()
  local configs = require "nvim-treesitter.configs"

  vim.g.markdown_fenced_languages = { "html", "python", "lua", "vim", "typescript", "javascript", "sql" }

  require("ts_context_commentstring").setup({})

  configs.setup({
    ensure_installed = {
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
    },
    sync_install = false,
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {}, -- list of language that will be disabled
      additional_vim_regex_highlighting = false, -- disable since it creates weird highlights in typescript
    },
    indent = { enable = true, disable = { "yaml" } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        --scope_incremental = "<S-CR>",
        node_decremental = "<S-CR>",
      },
    },
  })
end

return M
