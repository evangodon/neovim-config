local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Save
map('n', '<C-s>', ':w<CR>', opts)

-- better window movement
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- resize with arrows
map('n', '<C-Up>', ':resize -2<CR>', opts)
map('n', '<C-Down>', ':resize +2<CR>', opts)
map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)


-- better indenting
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Move selected line / block of text in visual mode
map('x', 'K', ':move \'<-2<CR>gv-gv', opts)
map('x', 'J', ':move \'>+1<CR>gv-gv', opts)

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)
map("v", "p", '"_dP', opts)


-- Press jk fast to enter
map("i", "jk", "<ESC>", opts)

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')

-- When going up or down one line, use displayed lines instead of physical lines
map('n', 'k', 'gk', opts)
map('n', 'j', 'gj', opts)
map('v', 'k', 'gk', opts)
map('v', '$', 'g$', opts)

-- Navigate to beginning or ending of line
map('n', 'H', '0', opts)
map('v', 'H', '0', opts)
map('n', 'L', '$', opts)
map('v', 'L', '$', opts)

-- Tab switch buffer
map('n', '<TAB>', ':bnext<CR>', opts)
map('n', '<C-n>', ':bnext<CR>', opts)
map('n', '<S-TAB>', ':bprevious<CR>', opts)

-- Searching
map('n', '<C-f>', ':BLines<CR>', opts) -- Search in file
map('n', '<C-P>', ':Files<CR>', opts) -- Search for file

-- Which key
local wk = require("which-key")

map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Terminal
map("n", "<leader><Enter>", ":ToggleTerm<CR>", opts)
map('t', '<Esc><Esc>', [[<C-\><C-N> :q<CR>]], opts)

-- Closing and Quitting
map('n', "<leader>bd", ":BufferClose<CR>", opts) -- Close Buffer
map("n", "<leader>q", ":q!<CR>", opts) -- Quit Neovim without saving

-- Zen mode

map("n", "<leader>G", ":LazyGit<CR>", opts)


-- Open Tree
map("n", "<leader>e", ":Lexplore<CR>", opts)
