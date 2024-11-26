-- catppuccin

local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
}

function M.config()
  local catppuccin = require "catppuccin"
  local util = require "catppuccin.utils.colors"

  local no_color = "NONE"

  catppuccin.setup({
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.2,
    },
    integrations = {
      nvimtree = {
        enabled = true,
        show_root = true,
      },
    },
    custom_highlights = function(colors)
      return {
        GitSignsDeleteLn = { fg = colors.red, bg = no_color },
        Visual = { fg = colors.text, bg = util.darken(colors.mauve, 0.08, colors.base) },
        VertSplit = { bg = colors.crust, fg = colors.crust },
        TabLineSel = { fg = colors.blue, bg = colors.mantle },
        TabLine = { fg = colors.overlay2, bg = colors.mantle },
        WarningMsg = { fg = colors.flamingo },
        --lualine
        DiffAdd = { fg = colors.green, bg = no_color },
        DiffChange = { fg = colors.yellow, bg = no_color },
        DiffDelete = { fg = colors.maroon, bg = no_color },
        -- IndentBlankline
        IndentBlanklineIndent1 = { fg = util.darken(colors.surface1, 0.2, colors.base), bg = colors.none },
        -- NvimTree
        NvimTreeCursorLine = { bg = util.darken(colors.mauve, 0.08, colors.base) },
        NvimTreeCursorLineNC = { bg = util.darken(colors.mauve, 0.15, colors.base) },
        -- GitSigns
        GitSignsChange = { fg = colors.yellow, bg = no_color },
        GitSignsAdd = { fg = colors.green, bg = no_color },
        GitSignsDelete = { fg = colors.red, bg = no_color },
        RenderMarkdownH1Bg = { fg = colors.red, bg = no_color },
        RenderMarkdownH2Bg = { fg = colors.peach, bg = no_color },
        RenderMarkdownH3Bg = { fg = colors.yellow, bg = no_color },
        RenderMarkdownH4Bg = { fg = colors.green, bg = no_color },
        RenderMarkdownH5Bg = { fg = colors.sky, bg = no_color },
        RenderMarkdownH6Bg = { fg = colors.lavender, bg = no_color },
      }
    end,
    color_overrides = {
      mocha = {},
    },
  })
end

return M
