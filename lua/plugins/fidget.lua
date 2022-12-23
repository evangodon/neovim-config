local M = {
	"j-hui/fidget.nvim",
}

function M.config()
	local fidget = require "fidget"

	fidget.setup({
		text = {
			spinner = "dots_pulse",
		},
	})
end

return M
