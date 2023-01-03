local M = {
	"jinh0/eyeliner.nvim",
	enabled = false,
	keys = {
		"f",
		"F",
	},
}

function M.config()
	local eyeliner = require "eyeliner"
	eyeliner.setup({
		highlight_on_key = true,
	})
end

return M
