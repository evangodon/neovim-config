-- Catppuccin, with the custom Embark-derived dark palette.
--

local notify = require "util.notify"
local colors = require "util.colors"

--- Light palette overrides, darkened so every accent clears 3.0 against base.
---@type table<string, string>
local embark_light = {
  rosewater = "#cf6b58",
  flamingo = "#d45959",
  pink = "#d924a8",
  mauve = "#9449ef",
  red = "#d10f4f",
  maroon = "#dc1659",
  peach = "#b85d13",
  yellow = "#bd7f00",
  green = "#198f65",
  teal = "#0d9f9e",
  sky = "#0c9393",
  sapphire = "#0083bd",
  blue = "#0a61ff",
  lavender = "#5252ff",
  text = "#2E2F45",
  subtext1 = "#5a6374",
  subtext0 = "#6b7687",
  overlay2 = "#7e8a9e",
  overlay1 = "#929db6",
  overlay0 = "#a4b0c6",
  surface2 = "#b0b8d1",
  surface1 = "#d0d5e3",
  surface0 = "#e2e6f1",
  base = "#f4f7fc",
  mantle = "#f1f5fc",
  crust = "#e2e7f0",
}

---@type table<string, string>
local embark_dark = {
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
  -- TODO make crust darker
  mantle = "#19172A",
  crust = "#100E23",
}

---@type string
local light_flavour = "catppuccin-latte"

---@type string
local dark_flavour = "catppuccin-mocha"

--- Decide whether to use the light flavour, from the clock or the environment override.
---@return boolean
local function should_use_light()
  local hour = tonumber(os.date "%H")
  local light = hour ~= nil and hour > 6 and hour < 20

  local override = os.getenv "NVIM_USE_DARK_THEME"
  if override == "true" then
    return false
  end

  if override == "false" then
    return true
  end

  if override ~= nil and override ~= "" then
    notify.warn(string.format('Ignoring NVIM_USE_DARK_THEME=%q, expected "true" or "false"', override))
  end

  return light
end

--- Match the float border background to the normal float background.
---@return nil
local function set_float_border()
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.get("NormalFloat", "bg#") })
end

--- Apply the flavour for the current time of day.
---@return nil
local function apply_theme()
  local light = should_use_light()
  local flavour = light and light_flavour or dark_flavour

  vim.o.background = light and "light" or "dark"

  local ok = pcall(vim.cmd.colorscheme, flavour)
  if not ok then
    notify.error(string.format("colorscheme %s not found", flavour))
    return
  end

  set_float_border()
end

local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
}

---@return nil
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
    ---@param palette table<string, string>
    ---@return table<string, table>
    custom_highlights = function(palette)
      local nvim_tree_accent_color = palette.blue

      return {
        GitSignsDeleteLn = { fg = palette.red, bg = no_color },
        Visual = { fg = palette.text, bg = util.darken(palette.mauve, 0.08, palette.base) },
        VertSplit = { bg = palette.crust, fg = palette.crust },
        WarningMsg = { fg = palette.flamingo },

        -- TabLine
        TabLineSel = { bg = palette.base, fg = palette.blue },
        TabLine = { fg = palette.overlay2, bg = palette.mantle },
        TabLineLogo = { fg = palette.blue, bg = palette.mantle },
        TabLineHeaderNeo = { bg = palette.mantle, fg = palette.blue, italic = true },
        TabLineHeaderVim = { bg = palette.mantle, fg = palette.blue, italic = false, bold = true },

        -- Winbar
        WinBar = { fg = palette.subtext1, bg = palette.base },
        WinBarNC = { fg = palette.subtext1, bg = palette.overlay2 },

        -- Grapple
        GrappleNormal = { bg = palette.base },
        GrappleBorder = { bg = palette.base },

        -- lualine
        DiffAdd = { fg = palette.green, bg = no_color },
        DiffChange = { fg = palette.yellow, bg = no_color },
        DiffDelete = { fg = palette.maroon, bg = no_color },

        -- IndentBlankline
        IndentBlanklineIndent1 = { fg = util.darken(palette.surface1, 0.2, palette.base), bg = palette.none },

        -- NvimTree
        NvimTreeCursorLine = { bg = util.darken(palette.mauve, 0.08, palette.base) },
        NvimTreeCursorLineNC = { bg = util.darken(palette.mauve, 0.15, palette.base) },
        NvimTreeFolderIcon = { fg = nvim_tree_accent_color },
        NvimTreeFolderName = { fg = nvim_tree_accent_color },
        NvimTreeOpenedFolderName = { fg = nvim_tree_accent_color },
        NvimTreeOpenedFolderIcon = { fg = nvim_tree_accent_color },
        NvimTreeFileIcon = { fg = nvim_tree_accent_color },

        -- GitSigns
        GitSignsChange = { fg = palette.yellow, bg = no_color },
        GitSignsAdd = { fg = palette.green, bg = no_color },
        GitSignsDelete = { fg = palette.red, bg = no_color },

        -- RenderMarkdown
        RenderMarkdownH1Bg = { fg = palette.red, bg = no_color },
        RenderMarkdownH2Bg = { fg = palette.peach, bg = no_color },
        RenderMarkdownH3Bg = { fg = palette.yellow, bg = no_color },
        RenderMarkdownH4Bg = { fg = palette.green, bg = no_color },
        RenderMarkdownH5Bg = { fg = palette.sky, bg = no_color },
        RenderMarkdownH6Bg = { fg = palette.lavender, bg = no_color },

        -- Telescope
        TelescopeNormal = { bg = palette.crust },
        TelescopeBorder = { fg = palette.green, bg = palette.crust },
        TelescopePromptNormal = { bg = palette.crust },
        TelescopePrompt = { fg = palette.red, bg = palette.crust },
        TelescopeMatching = { fg = palette.red },
        TelescopeSelectionCaret = { fg = palette.red, bg = palette.mantle },
        TelescopeSelection = { bg = palette.mantle },
        TelescopePromptPrefix = { fg = palette.green, bg = palette.crust },

        -- Code tokens
        String = { fg = palette.green },
        ["@tag"] = { fg = palette.sky },
        ["@tag.attribute.tsx"] = { fg = palette.yellow },
      }
    end,
    color_overrides = {
      latte = embark_light,
      mocha = embark_dark,
    },
  })

  apply_theme()

  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Keep the float border aligned with the float background",
    group = vim.api.nvim_create_augroup("theme", { clear = true }),
    callback = set_float_border,
  })
end

return M
