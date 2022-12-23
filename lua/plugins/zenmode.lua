-- Zen-mode
-- https://github.com/folke/zen-mode.nvim
--
local M = {
	"folke/zen-mode.nvim",
}

function M.config()
	local zenmode = require "zen-mode"
	local fn = require "user.functions"

	zenmode.setup({
		window = {
			backdrop = 1,
			width = 100,
			height = 30,
		},
		plugins = {
			gitsigns = { enabled = false },
			kitty = {
				enabled = false,
				font = "+4",
			},
		},
		on_open = function()
			vim.cmd [[
		  ScrollbarHide
		  Gitsigns toggle_signs false
		]]
		end,
		on_close = function()
			vim.cmd [[ScrollbarShow]]
		end,
	})

	fn.leaderKeymaps({
		Z = {
			":noautocmd ZenMode<CR>",
			"Zen Mode",
		},
	})
end

return M
