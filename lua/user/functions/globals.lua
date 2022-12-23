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
}

-- Pretty print lua code with Notify
function P(value)
	if type(value) == "table" then
		Notify.info(vim.inspect(value))
		return
	end
	Notify.info(value)
end

function Get_loaded_buffers()
	local loaded_buffers = vim.tbl_filter(function(buf)
		return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
	end, vim.api.nvim_list_bufs())
	return loaded_buffers
end

-- Format string for ex command
function CMD(command)
	return string.format(":%s<cr>", command)
end
