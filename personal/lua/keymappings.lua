
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true}


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

-- Move selected line / block of text in visual mode
map('x', 'K', ':move \'<-2<CR>gv-gv', opts)
map('x', 'J', ':move \'>+1<CR>gv-gv', opts)

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')

-- When going up or down one line, use displayed lines instead of physical lines
map('n', 'k', 'gk', {noremap = true})
map('n', 'j', 'gj', {noremap = true})
map('v', 'k', 'gk', {noremap = true})
map('v', '$', 'g$', {noremap = true})

-- Navigate to beginning or ending of line
map('n', 'H', '0', opts)
map('v', 'H', '0', opts)
map('v', 'L', '$', opts)

-- Tab switch buffer
map('n', '<TAB>', ':bnext<CR>', opts)
map('n', '<C-n>', ':bnext<CR>', opts)
map('n', '<S-TAB>', ':bprevious<CR>', opts)

-- Toggle comment line
map('n', '<C-_', '<Plug>NERDCommenterToggle', {noremap = true})
map('v', '<C-_', '<Plug>NERDCommenterToggle<CR>gv', {noremap = true})

-- Search
map('n', '<C-f>', ':BLines<CR>', opts)
map('n', '<C-P>', ':Files<CR>', opts)

map('n', "<leader>c", ":BufferClose<CR>", opts)

-- Which key
local wk = require("which-key")

vim.g.mapleader = ' '

map("n", "<leader><Enter>", ":ToggleTerm<CR>", opts)
map('t', '<Esc>', '<C-\\><C-n>', opts)

-- Zen mode
map("n", "<leader>Z", ":Goyo<CR>", opts)

-- Quit
map("n", "<leader>q", ":q!<CR>", opts)


require("which-key").setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ...
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 1, 1, 1}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true -- show help message on the command line when the popup is visible
}



wk.register({
}, { prefix = "<leader>"})
