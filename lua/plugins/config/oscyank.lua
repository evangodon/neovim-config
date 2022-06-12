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
		title = "Copied to system clipboard",
		on_open = function(win)
			local buf = vim.api.nvim_win_get_buf(win)
			vim.api.nvim_buf_set_option(buf, "filetype", "lua")
		end,
	})
end

local keymap_desc = "Copy visual selection to system clipboard"
vim.keymap.set("x", "Y", setToSystemClipboard, { desc = keymap_desc })
vim.keymap.set("x", "<C-c>", setToSystemClipboard, { desc = keymap_desc })
