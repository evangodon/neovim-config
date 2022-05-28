require "user.settings"
require "user.keymaps"

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true}

function vscodeCmd(cmd)
  return ":call VSCodeNotify('"..cmd.."')<CR>"
end

map("n", "<leader>ut", vscodeCmd("workbench.action.selectTheme"), opts)