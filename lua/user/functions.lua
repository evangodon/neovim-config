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

local M = {}

-- Reload config
M.reloadConfig = function()
	-- Remove all autocmds
	vim.cmd [[autocmd!]]
	-- Certain packages complain when setup is called twice
	package.loaded["nvim-tree"] = nil
	package.loaded["which-key"] = nil

	-- My config
	for name, _ in pairs(package.loaded) do
		if name:match "^user." or name:match "^plugins." then
			package.loaded[name] = nil
		end
	end

	dofile(vim.env.MYVIMRC)
	require("notify").notify "Reloaded config"
end

local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

-- Set leader keymappings
M.leaderKeymaps = function(keys, opts)
	local defaults = vim.tbl_extend("keep", { prefix = "<leader>" }, opts or {})
	wk.register(keys, defaults)
end

return M
