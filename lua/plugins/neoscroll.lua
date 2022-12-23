local M = {
	"karb94/neoscroll.nvim",
}

function M.config()
	local neoscroll = require "neoscroll"

	neoscroll.setup({
		mappings = {
			"<C-u>",
			"<C-d",
			"zz",
		},
	})
end

return M
