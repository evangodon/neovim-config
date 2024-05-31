local M = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "BufReadPre",
}

function M.config()
  local indent_blankline = require "ibl"

  local highlight = {
    "Whitespace",
    "Whitespace",
  }

  indent_blankline.setup({
    indent = {
      char = "│",
      tab_char = nil,
      highlight = highlight,
      smart_indent_cap = false,
      priority = 1,
      repeat_linebreak = true,
    },
    whitespace = {
      highlight = highlight,
      remove_blankline_trail = false,
    },
    scope = {
      show_start = false,
      show_end = false,
      highlight = "Whitespace",
      exclude = {
        language = {
          "markdown",
          "help",
        },
      },
    },
  })
end

return M
