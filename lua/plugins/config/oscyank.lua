local notify = require "notify"

-- Use OSCYANK to copy visual selection to system clipboard
local function setToSystemClipboard()
	local register = "o"

	-- set to register
	vim.cmd(string.format('noautocmd normal! "%sy', register))

	-- use Oscyank to set to clipboard
	vim.cmd("OSCYankReg " .. register)

	-- Show what was copied
	local copied = vim.fn.getreg(register)
	notify(copied, "info", {
		title = "Copied to clipboard",
		on_open = function(win)
			local buf = vim.api.nvim_win_get_buf(win)
			vim.api.nvim_buf_set_option(buf, "filetype", "lua")
		end,
	})
end

vim.keymap.set("x", "Y", setToSystemClipboard, { desc = "Yank to system clipboard with vim-oscyank" })
