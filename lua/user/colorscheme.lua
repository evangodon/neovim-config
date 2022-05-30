local hour = tonumber(os.date "%H")
local is_day = hour < 19 and hour > 6

local LIGHT_THEME = "github_light_default"
local DARK_THEME = "catppuccin"

local colorscheme = is_day and LIGHT_THEME or DARK_THEME

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

vim.g.catppuccin_flavour = "mocha"
local colors = require("catppuccin.api.colors").get_colors()

catppuccin.setup()
catppuccin.remap({
	Comment = { fg = colors.overlay1 },
	LineNr = { fg = colors.overlay1 },
	CursorLineNr = { fg = colors.sky },
	DiagnosticError = { bg = colors.none },
	DiagnosticInfo = { bg = colors.none },
	DiagnosticHint = { bg = colors.none },
	DiagnosticWarn = { bg = colors.none },
})
