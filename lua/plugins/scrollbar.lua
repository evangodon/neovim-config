-- Nvim-scrollbar
-- https://github.com/petertriho/nvim-scrollbar

local status_ok, scrollbar = pcall(require, "scrollbar")
if not status_ok then
	return
end

-- Set scrollbar color
local scrollbar_handle = {}
if vim.g.colors_name == "catppuccin" then
	local colors = require("catppuccin.api.colors").get_colors()
	scrollbar_handle = {
		color = colors.surface0,
	}
end

scrollbar.setup({
	handle = scrollbar_handle,
})
