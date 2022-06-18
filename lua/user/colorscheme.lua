local hour = tonumber(os.date "%H")
local dark_theme_env_var = os.getenv "NVIM_USE_DARK_THEME"
local use_light_theme = hour < 19 and hour > 6
if dark_theme_env_var then
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

-- catppuccin
local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
	Notify.error "catppuccin not found!"
	return
end

local colors = require("catppuccin.api.colors").get_colors()
local util = require "catppuccin.utils.util"

-- needs to be called before setting the colorscheme
-- https://github.com/catppuccin/nvim/tree/main/lua/catppuccin/core/integrations
catppuccin.remap({
	CursorLine = { bg = util.darken(colors.sky, 0.08, colors.base) },
	GitSignsDeleteLn = { fg = colors.red, bg = colors.none },
	Visual = { fg = colors.text, bg = util.darken(colors.mauve, 0.08, colors.base) },
	IndentBlanklineIndent1 = { fg = util.darken(colors.surface1, 0.2, colors.base), bg = colors.none },
})
catppuccin.setup({
	integrations = {
		nvimtree = {
			enabled = true,
			show_root = true,
		},
	},
})

-- Set colorscheme
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

-- Dim inactive windows
vim.api.nvim_set_hl(0, "InactiveWindow", { bg = colors.mantle, fg = colors.none })
vim.api.nvim_set_hl(0, "ActiveWindow", { bg = colors.base, fg = colors.none })
local function getWinHighlight(highlights)
	return "Normal:ActiveWindow,NormalNC:InactiveWindow," .. highlights
end
vim.opt_local.winhighlight = getWinHighlight "SignColumn:ActiveWindow"

local wm_group = vim.api.nvim_create_augroup("WindowManagement", {})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
	group = wm_group,
	callback = function()
		vim.opt_local.winhighlight = getWinHighlight "SignColumn:ActiveWindow,CursorLineSign:ActiveWindow"
		local ft = vim.bo.filetype
		vim.cmd("Gitsigns toggle_signs " .. tostring(not vim.tbl_contains({ "NvimTree" }, ft)))
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = wm_group,
	callback = function()
		vim.opt_local.winhighlight = getWinHighlight "SignColumn:InactiveWindow,CursorLineSign:InactiveWindow"
	end,
})
