require "user.settings"
require "user.keymaps"

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local function vscodeCmd(cmd)
	return ":call VSCodeNotify('" .. cmd .. "')<CR>"
end

keymap("n", "<leader>ut", vscodeCmd "workbench.action.selectTheme", opts)

-- Navigation
keymap("n", "[b", vscodeCmd "workbench.action.previousEditor", opts)
keymap("n", "]b", vscodeCmd "workbench.action.nextEditor", opts)
