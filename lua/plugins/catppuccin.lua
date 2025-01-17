-- catppuccin

local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
}

local colorOverridesEmbarkLight = {
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#F02E6E",
  maroon = "#F48FB1",
  peach = "#F2B482",
  yellow = "#FFE6B3",
  green = "#7FE9C3",
  teal = "#ABF8F7",
  sky = "#63F2F1",
  sapphire = "#91DDFF",
  blue = "#78A8FF",
  lavender = "#7676FF",
  text = "#2E2F45",
  subtext1 = "#a4b0c6",
  subtext0 = "#929db6",
  overlay2 = "#7e8a9e",
  overlay1 = "#6b7687",
  overlay0 = "#5a6374",
  surface2 = "#e2e6f1",
  surface1 = "#d0d5e3",
  surface0 = "#b0b8d1",
  base = "#f1f5fc",
  mantle = "#e2e7f0",
  crust = "#f4f7fc",
}

local colorOverridesEmbark = {
  rosewater = "#e8d8d3",
  flamingo = "#e0b8b8",
  pink = "#e2b6d4",
  mauve = "#b395d7",
  red = "#F02E6E",
  maroon = "#F48FB1",
  peach = "#F2B482",
  yellow = "#FFE6B3",
  green = "#7FE9C3",
  teal = "#ABF8F7",
  sky = "#63F2F1",
  sapphire = "#91DDFF",
  blue = "#78A8FF",
  lavender = "#7676FF",
  text = "#CBE3E7",
  subtext1 = "#a4b0c6",
  subtext0 = "#929db6",
  overlay2 = "#7e8a9e",
  overlay1 = "#6b7687",
  overlay0 = "#5a6374",
  surface2 = "#4a4f63",
  surface1 = "#585273",
  surface0 = "#3E3859",
  base = "#1E1C31",
  -- TODO make  crust darker
  mantle = "#19172A",
  crust = "#100E23",
}

function M.config()
  local catppuccin = require "catppuccin"
  local util = require "catppuccin.utils.colors"

  local no_color = "NONE"

  catppuccin.setup({
    dim_inactive = {
      enabled = true,
      shade = "dark",
      percentage = 0.2,
    },
    integrations = {
      nvimtree = {
        enabled = true,
        show_root = true,
      },
      gitsigns = true,
      notify = true,
      treesitter = true,
      cmp = true,
      telescope = false,
    },
    custom_highlights = function(colors)
      local accent_color = colors.green
      local nvim_tree_accent_color = colors.blue

      return {
        GitSignsDeleteLn = { fg = colors.red, bg = no_color },
        Visual = { fg = colors.text, bg = util.darken(colors.mauve, 0.08, colors.base) },
        VertSplit = { bg = colors.crust, fg = colors.crust },
        TabLineSel = { bg = colors.base, fg = colors.blue },
        TabLine = { fg = colors.overlay2, bg = colors.mantle },
        WarningMsg = { fg = colors.flamingo },

        -- Winbar
        WinBar = { fg = colors.subtext1, bg = colors.base },
        WinBarNC = { fg = colors.subtext1, bg = colors.overlay2 },

        --lualine
        DiffAdd = { fg = colors.green, bg = no_color },
        DiffChange = { fg = colors.yellow, bg = no_color },
        DiffDelete = { fg = colors.maroon, bg = no_color },
        -- IndentBlankline
        IndentBlanklineIndent1 = { fg = util.darken(colors.surface1, 0.2, colors.base), bg = colors.none },

        -- NvimTree
        NvimTreeCursorLine = { bg = util.darken(colors.mauve, 0.08, colors.base) },
        NvimTreeCursorLineNC = { bg = util.darken(colors.mauve, 0.15, colors.base) },
        NvimTreeFolderIcon = { fg = nvim_tree_accent_color },
        NvimTreeFolderName = { fg = nvim_tree_accent_color },
        NvimTreeOpenedFolderName = { fg = nvim_tree_accent_color },
        NvimTreeOpenedFolderIcon = { fg = nvim_tree_accent_color },
        NvimTreeFileIcon = { fg = nvim_tree_accent_color },

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

        --Telescope
        TelescopeNormal = { bg = colors.crust },
        TelescopeBorder = { fg = colors.green, bg = colors.crust },
        TelescopePromptNormal = { bg = colors.crust },
        TelescopePrompt = { fg = colors.red, bg = colors.crust },
        TelescopeMatching = { fg = colors.red },
        TelescopeSelectionCaret = { fg = colors.red },
        TelescopePromptPrefix = { fg = colors.green, bg = colors.crust },

        -- Code tokens
        String = { fg = colors.green },
        ["@tag"] = { fg = colors.sky },
        ["@tag.attribute.tsx"] = { fg = colors.yellow },
      }
    end,
    color_overrides = {
      -- todo: fix colors
      -- latte = colorOverridesEmbarkLight,
      mocha = colorOverridesEmbark,
    },
  })
end

return M
