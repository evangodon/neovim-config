-- better window movement
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {silent = true})

-- resize with arrows
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize +2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>', {silent = true})


-- better indenting
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

-- Move selected line / block of text in visual mode
vim.api.nvim_set_keymap('x', 'K', ':move \'<-2<CR>gv-gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', 'J', ':move \'>+1<CR>gv-gv', {noremap = true, silent = true})

-- Better nav for omnicomplete
vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')

-- When going up or down one line, use displayed lines instead of physical lines
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('v', 'k', 'gk', {noremap = true})
vim.api.nvim_set_keymap('v', '$', 'g$', {noremap = true})

-- Navigate to beginning or ending of line
vim.api.nvim_set_keymap('n', 'H', '0', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'L', '$', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'H', '0', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'L', '$', {noremap = true, silent = true})

-- Tab switch buffer
vim.api.nvim_set_keymap('n', '<TAB>', ':bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-n>', ':bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-TAB>', ':bprevious<CR>', {noremap = true, silent = true})

-- Terminal 
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<Esc><Esc>', '<C-\\><C-n>:FloatermHide<CR>', {noremap = true, silent = true})


-- Toggle comment line
vim.api.nvim_set_keymap('n', '<C-_', '<Plug>NERDCommenterToggle', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-_', '<Plug>NERDCommenterToggle<CR>gv', {noremap = true})

-- Search
vim.api.nvim_set_keymap('n', '<C-f>', ':BLines<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-P>', ':Files<CR>', {noremap = true, silent = true})


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

local wk = require("which-key")

vim.g.mapleader = ' '

vim.api.nvim_set_keymap("n", "<leader>Z", ":Goyo<CR>", {noremap = true, silent = true})

vim.api.nvim_set_keymap("n", "<leader><Enter>", ":FloatermToggle<CR>", {noremap = true, silent = true})

vim.api.nvim_set_keymap("n", "<leader>Q", ":q!<CR>", {noremap = true, silent = true})


wk.register({
}, { prefix = "<leader>"})
