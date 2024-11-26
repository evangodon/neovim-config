local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Save
keymap("n", "<C-s>", function()
  vim.cmd "silent! update"
end, { desc = "Save the file if modified", noremap = true, silent = true })

-- better window movement
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- resize with arrows
keymap("n", "<C-Up>", CMD "resize +3", opts)
keymap("n", "<C-Down>", CMD "resize -3", opts)
keymap("n", "<C-Left>", CMD "vertical resize +3", opts)
keymap("n", "<C-Right>", CMD "vertical resize -3", opts)

-- better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Navigate buffers
keymap("n", "]b", CMD "bnext", opts) -- Next buffer
keymap("n", "<C-n>", CMD "bnext", opts)
keymap("n", "<TAB>", CMD "bnext", opts)
keymap("n", "[b", CMD "bprevious", opts) -- Previous buffer
keymap("n", "<S-TAB>", CMD "bprevious", opts)
keymap("n", "<BS>", CMD "b#", opts)
keymap("n", "<leader>\\", CMD "Telescope buffers", opts)

-- Navigate quickfix list
local function set_quickfix_keymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<TAB>", CMD "cnext", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<S-TAB>", CMD "cprev", opts)
end

-- Autocommand to set keymaps when entering a quickfix buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = set_quickfix_keymaps,
})

vim.api.nvim_del_keymap("n", "<C-W>d")
vim.api.nvim_del_keymap("n", "<C-W><C-D>")
vim.api.nvim_create_user_command("CloseBuffer", function()
  local loaded_buffers = Get_loaded_buffers()
  if #loaded_buffers == 0 then
    return
  elseif #loaded_buffers == 1 then
    vim.cmd "confirm bdelete"
    vim.cmd "Alpha"
    vim.cmd "bdelete#"
  else
    vim.cmd "bprevious|confirm bdelete#"
  end
end, {})
keymap("n", "<C-w>", CMD "CloseBuffer", opts)

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- When going up or down one line, use displayed lines instead of physical lines
keymap("n", "k", "gk", opts)
keymap("n", "j", "gj", opts)
keymap("v", "k", "gk", opts)
keymap("v", "$", "g$", opts)

-- Navigate to beginning or ending of line
keymap("n", "H", "0", opts)
keymap("v", "H", "0", opts)
keymap("n", "L", "$", opts)
keymap("v", "L", "$", opts)

-- Start search and replace in visual mode
keymap("v", "f", ":s/", opts)

-- Prevent overiding the last yank when deleting empty line
keymap("n", "dd", function()
  if vim.api.nvim_get_current_line():match "^%s*$" then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true, noremap = true })

keymap("", "<Space>", "<Nop>", opts)

-- Terminal
keymap("t", "<Esc><Esc>", [[<C-\><C-N> :q<CR>]], opts)

-- Disable recording
keymap("n", "Q", "<nop>", opts)
keymap("n", "q", "<nop>", opts)

-- Leader key mappings

local fn = require "user.functions.utils"
local wk = require "which-key"

wk.add({
  { LeaderKey "q", CMD "quitall!", desc = "Force quit" },
  { LeaderKey "c", CMD "close", desc = "Close window" },
  { LeaderKey "O", CMD "OpenSlides", desc = "Open file in slides" },
  { LeaderKey "B", fn.close_all_buffers_but_current, desc = "Close all buffers but current" },
})

wk.add({
  { LeaderKey "T", group = "Toggle option" },
  { LeaderKey "Tc", fn.toggle_option "cursorcolumn", desc = "Toggle cursorcolumn" },
  { LeaderKey "Tr", fn.toggle_option "relativenumber", desc = "Toggle relativenumber" },
})
