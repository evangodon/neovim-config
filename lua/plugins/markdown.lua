local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  opts = {},
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
}

-- format string used for headers
local function h(n)
  local header_char = "█"
  return string.rep(header_char, n) .. " "
end

M.config = function()
  require("render-markdown").setup({
    heading = {
      -- Replaces '#+'
      icons = { h(1), h(2), h(3), h(4), h(5), h(6) },
      -- Added to the sign column if enabled
      signs = { "" },
      width = "block",
      right_pad = 1,
    },
    bullet = {
      icons = { "•", "◦", "▸", "▹" },
    },
    checkbox = {
      unchecked = {
        icon = "  󰄱 ",
      },
      checked = {
        icon = "  󰱒 ",
      },
      custom = {
        inprogress = { raw = "[-]", rendered = "  󰥔", highlight = "RenderMarkdownTodo" },
        moved = { raw = "[->]", rendered = "  ->", highlight = "RenderMarkdownTodo" },
      },
    },
    code = {
      -- Determines how code blocks & inline code are rendered:
      --  none:     disables all rendering
      --  normal:   adds highlight group to code blocks & inline code, adds padding to code blocks
      --  language: adds language icon to sign column if enabled and icon + name above code blocks
      --  full:     normal + language
      style = "language",
      -- Determines where language icon is rendered:
      --  right: right side of code block
      --  left:  left side of code block
      position = "left",
      -- Amount of padding to add around the language
      language_pad = 0,
      -- An array of language names for which background highlighting will be disabled
      -- Likely because that language has background highlights itself
      disable_background = { "diff" },
      -- Width of the code block background:
      --  block: width of the code block
      --  full:  full width of the window
      width = "block",
      -- Amount of padding to add to the left of code blocks
      left_pad = 0,
      -- Amount of padding to add to the right of code blocks when width is 'block'
      right_pad = 1,
      -- Minimum width to use for code blocks when width is 'block'
      min_width = 0,
    },
  })
end

return M
