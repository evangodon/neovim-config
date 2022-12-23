-- Notify
-- https://github.com/rcarriga/nvim-notify

local M = {
	"rcarriga/nvim-notify",
}

function M.config()
	local notify = require "notify"

	notify.setup({
		fps = 30,
		icons = {
			DEBUG = "  ",
			ERROR = "  ",
			INFO = "  ",
			TRACE = "✎ ",
			WARN = "  ",
		},
		level = "info",
		minimum_width = 50,
		render = "default",
		stages = "static",
		timeout = 3000,
	})
end

return M
