--
-- Global functions
--

local notify_status_ok, notify = pcall(require, "notify")
if not notify_status_ok then
	notify = vim.notify
end

-- Global notification function
Notify = {
	info = function(msg)
		notify(msg, vim.log.levels.INFO)
	end,
	warn = function(msg)
		notify(msg, vim.log.levels.WARN)
	end,

	error = function(msg)
		notify(msg, vim.log.levels.ERROR)
	end,
	async = notify.async,
}

-- Pretty print lua code with Notify
function P(value)
	if type(value) == "table" then
		Notify.info(vim.inspect(value))
		return
	end
	Notify.info(value)
end
