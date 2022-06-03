local hour = tonumber(os.date "%H")
local dark_theme_env_var = os.getenv "NVIM_USE_DARK_THEME"
local use_light_theme = dark_theme_env_var and dark_theme_env_var == "false" or hour < 19 and hour > 6

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
