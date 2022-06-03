local hour = tonumber(os.date "%H")
local dark_theme_env_var = os.getenv "NVIM_USE_DARK_THEME"
local use_light_theme = hour < 19 and hour > 6

if dark_theme_env_var then
	print(dark_theme_env_var)
	local stringToBool = {
		["true"] = true,
		["false"] = false,
	}
	use_light_theme = not stringToBool[dark_theme_env_var]
end

local LIGHT_THEME = "catppuccin"
local DARK_THEME = "catppuccin"

local colorscheme = use_light_theme and LIGHT_THEME or DARK_THEME

vim.g.catppuccin_flavour = use_light_theme and "latte" or "macchiato"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

-- catppuccin
local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
	return
end

local colors = require("catppuccin.api.colors").get_colors()
local util = require "catppuccin.utils.util"

-- Set CursorLine color
vim.cmd(":highlight CursorLine guibg=" .. util.darken(colors.sky, 0.08, colors.base))

catppuccin.setup({
	integration = {
		nvimtree = {
			enabled = true,
			show_root = true,
		},
	},
})
catppuccin.remap({
	DiagnosticError = { bg = colors.none },
	DiagnosticInfo = { bg = colors.none },
	DiagnosticHint = { bg = colors.none },
	DiagnosticWarn = { bg = colors.none },
})
