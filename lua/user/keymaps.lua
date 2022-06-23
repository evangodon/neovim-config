local fn = require "user.functions"
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Save
keymap("n", "<C-s>", ":w<CR>", opts)
-- better window movement
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- resize with arrows
keymap("n", "<C-Up>", ":resize +3<CR>", opts)
keymap("n", "<C-Down>", ":resize -3<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +3<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -3<CR>", opts)

-- better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Navigate buffers
keymap("n", "]b", ":bnext<CR>", opts) -- Next buffer
keymap("n", "<C-n>", ":bnext<CR>", opts)
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "[b", ":bprevious<CR>", opts) -- Previous buffer
keymap("n", "<S-TAB>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":Bdelete<CR>", opts) -- TODO: close all buffers but this one
keymap("n", "<C-w>", ":Bdelete<CR>", opts) -- Close buffer

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Better nav for omnicomplete
vim.cmd 'inoremap <expr> <c-j> ("\\<C-n>")'
vim.cmd 'inoremap <expr> <c-k> ("\\<C-p>")'

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

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Terminal
keymap("t", "<Esc><Esc>", [[<C-\><C-N> :q<CR>]], opts)


fn.leaderKeymaps({
	so = {
		fn.reloadConfig,
		"Reload config",
	},
	q = {
		":quitall!<CR>",
		"Quit",
	},
	l = {
		":noh<CR>",
		"Clear highlights",
	},
	c = {
		":close<CR>",
		"Close window",
	},
	C = {
		":Copilot status<CR>",
		"Check copilot status",
	},
	["-"] = {
		":b#<CR>",
		"return to last edited buffer",
	},
	["]"] = {
		":bnext<cr>",
		"Go to next buffer",
	},
	["["] = {
		":bprev<cr>",
		"Go to previous buffer",
	},
	T = {
		":edit ~/.config/nvim/todo.md<cr>",
		"Open nvim todo list",
	},
	t = {
		name = "Toggle an option",
		c = {
			function()
			  fn.toggleVimOption("cursorcolumn")
			end,
			"Toggle cursorcolumn",
		},
		n = {
			function()
			  fn.toggleVimOption("relativenumber")
			end,
			"Toggle relative number",
		},
	},
})
