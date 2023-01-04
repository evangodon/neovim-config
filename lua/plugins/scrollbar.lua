-- Nvim-scrollbar
-- https://github.com/petertriho/nvim-scrollbar
--
local M = {
	"petertriho/nvim-scrollbar",
	cmd = { "ZenMode" },
	event = "BufReadPre",
}

function M.config()
	local scrollbar = require "scrollbar"

	-- Set scrollbar color
	local scrollbar_handle = {}
	if vim.g.colors_name == "catppuccin" then
		local colors = require("catppuccin.palettes").get_palette()
		scrollbar_handle = {
			color = colors.surface0,
		}
	end

	-- Setup gitsigns integration
	local git_icon = "│"
	require("scrollbar.handlers.gitsigns").setup()

	scrollbar.setup({
		handle = scrollbar_handle,
		handlers = {
			gitsigns = false,
		},
		marks = {
			Cursor = {
				text = "•",
			},
			GitAdd = {
				text = git_icon,
			},
			GitChange = {
				text = git_icon,
			},
			GitDelete = {
				text = "▁",
			},
		},
		show_in_active_only = true,
		excluded_filetypes = {
			"NvimTree",
		},
	})
end

return M
