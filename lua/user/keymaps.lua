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
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Navigate buffers
keymap("n", "]b", ":bnext<CR>", opts)
keymap("n", "[b", ":bprevious<CR>", opts)

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

-- clearhightlights
keymap("n", "<leader>H", ":noh<CR>", opts) -- Quit Neovim without saving

-- Tab switch buffer
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "<C-n>", ":bnext<CR>", opts)
keymap("n", "<S-TAB>", ":bprevious<CR>", opts)

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Terminal
keymap("t", "<Esc><Esc>", [[<C-\><C-N> :q<CR>]], opts)

-- Closing and Quitting
keymap("n", "<leader>bd", ":Bdelete<CR>", opts) -- Close Buffer
keymap("n", "<C-w>", ":Bdelete<CR>", opts) -- Search for file
keymap("n", "<leader>q", ":q!<CR>", opts) -- Quit Neovim without saving

-- Reload config
local reloadConfig = function()
	for name, _ in pairs(package.loaded) do
		if name:match "^user." or name:match "^plugins." then
			package.loaded[name] = nil
		end
	end

	dofile(vim.env.MYVIMRC)
	require("notify").notify "Reloaded config"
end

keymap("n", "<leader>so", reloadConfig, opts) -- Quit Neovim without saving
