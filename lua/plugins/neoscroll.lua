local M = {
	"karb94/neoscroll.nvim",
	event = "BufReadPre",
}

function M.config()
	local neoscroll = require "neoscroll"

	neoscroll.setup({
		mappings = {
			"<C-u>",
			"<C-d>",
			"zz",
		},
		hide_cursor = true,
	})
end

return M
