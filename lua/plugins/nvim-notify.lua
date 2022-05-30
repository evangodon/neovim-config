-- Notify
-- https://github.com/rcarriga/nvim-notify

local status_ok, notify = pcall(require, "notify")
if not status_ok then
	return
end


notify.setup({
		background_colour = "Normal",
		fps = 30,
		icons = {
			DEBUG = "",
			ERROR = "",
			INFO = "",
			TRACE = "✎",
			WARN = "",
		},
		level = "info",
		minimum_width = 50,
		render = "default",
    stages = "static",
		timeout = 3000,
})
