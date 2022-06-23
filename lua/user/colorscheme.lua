local hour = tonumber(os.date "%H")
local dark_theme_env_var = os.getenv "NVIM_USE_DARK_THEME"
local use_light_theme = hour < 19 and hour > 6
if dark_theme_env_var then
	local stringToBool = { ["true"] = true, ["false"] = false }
	use_light_theme = not stringToBool[dark_theme_env_var]
end

local LIGHT_THEME = "catppuccin"
local DARK_THEME = "catppuccin"

local colorscheme = use_light_theme and LIGHT_THEME or DARK_THEME

vim.g.catppuccin_flavour = use_light_theme and "latte" or "mocha"

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
	NvimTreeCursorLine = { bg = util.darken(colors.mauve, 0.08, colors.base) },
	NvimTreeCursorLineNC = { bg = util.darken(colors.mauve, 0.15, colors.base) },
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

--
-- Dim inactive windows
--
vim.api.nvim_set_hl(0, "ActiveWindow", { bg = colors.base, fg = colors.none })
vim.api.nvim_set_hl(0, "InactiveWindow", { bg = colors.mantle, fg = colors.none })

local function getWinHighlight(highlights)
	local default_win_highlights = {
		Normal = "ActiveWindow",
		NormalNC = "InactiveWindow",
	}
	local win_highlights = vim.tbl_extend("force", default_win_highlights, highlights)

	local winhl_list = {}
	for key, value in pairs(win_highlights) do
		local highlight_link = string.format("%s:%s", key, value)
		table.insert(winhl_list, highlight_link)
	end

	local winhl_str = table.concat(winhl_list, ",")
	return winhl_str
end
vim.opt_local.winhighlight = getWinHighlight({ SignColumn = "ActiveWindow" })

local wm_group = vim.api.nvim_create_augroup("WindowManagement", {})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
	group = wm_group,
	callback = function()
		local ft = vim.bo.filetype
		local in_nvim_tree = ft == "NvimTree"

		local win_highlights = {
			SignColumn = "ActiveWindow",
			CursorLineSign = "ActiveWindow",
		}

		if in_nvim_tree then
			win_highlights["CursorLine"] = "NvimTreeCursorLine"
		end

		vim.opt_local.winhighlight = getWinHighlight(win_highlights)

		local enable = tostring(not in_nvim_tree)
		vim.cmd("Gitsigns toggle_signs " .. enable)
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = wm_group,
	callback = function()
		local ft = vim.bo.filetype
		local in_nvim_tree = ft == "NvimTree"

		local win_highlights = {
			SignColumn = "InactiveWindow",
			CursorLineSign = "InactiveWindow",
		}

		if in_nvim_tree then
			win_highlights["CursorLine"] = "NvimTreeCursorLineNC"
		end

		vim.opt_local.winhighlight = getWinHighlight(win_highlights)
	end,
})
