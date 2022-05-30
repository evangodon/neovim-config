require "user.settings"
require "user.keymaps"

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local vscodeCmd = function(cmd)
	return ":call VSCodeNotify('" .. cmd .. "')<CR>"
end

map("n", "<leader>ut", vscodeCmd "workbench.action.selectTheme", opts)
