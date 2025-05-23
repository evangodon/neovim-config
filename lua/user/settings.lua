-- :help options
local o = vim.opt

o.backup = false -- creates a backup file
o.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
o.cmdheight = 1 -- more space in the neovim command line for displaying messages
o.completeopt = { "menuone", "noselect" } -- mostly just for cmp
o.conceallevel = 2
-- o.fileencoding = "utf-8" -- the encoding written to a file
o.hlsearch = true -- highlight all matches on previous search pattern
o.ignorecase = true -- ignore case in search patterns
o.mouse = "a" -- allow the mouse to be used in neovim
o.pumheight = 10 -- pop up menu height
o.showmode = false -- we don't need to see things like -- INSERT -- anymore
o.showtabline = 2 -- always show tabs
o.smartcase = true -- smart case
o.smartindent = true -- make indenting smarter again
o.splitbelow = true -- force all horizontal splits to go below current window
o.splitright = true -- force all vertical splits to go to the right of current window
o.swapfile = false -- creates a swapfile
o.cmdheight = 0 -- hide cmd line

o.termguicolors = true -- set term gui colors (most terminals support this)
o.timeoutlen = 500 -- time to wait for a mapped sequence to complete (in milliseconds)
o.undofile = true -- enable persistent undo
o.updatetime = 300 -- faster completion (4000ms default)
o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
o.expandtab = true -- convert tabs to spaces
o.shiftwidth = 2 -- the number of spaces inserted for each indentation
o.tabstop = 2 -- insert 2 spaces for a tab
o.cursorline = true -- highlight the current line
o.number = true -- set numbered lines
o.relativenumber = true -- set relative numbered lines
o.numberwidth = 4 -- set number column width to 4 {default 4}
o.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
o.wrap = false -- display lines as one long line
o.scrolloff = 8 -- start scrolling before hitting top or bottom of screen
o.sidescrolloff = 8
o.laststatus = 3 -- set a global status line
o.guifont = "JetBrainsMono Nerd Font Mono:h18" -- the font used in graphical neovim applications
o.fillchars = { eob = " " } -- Don't show `~` character on nonexistent lines, and | character between buffers
o.fillchars:append "vert: "

-- o.shell = "/bin/fish"

local bo = vim.bo

bo.smartindent = true -- Makes indenting smart
bo.copyindent = true -- copy the previous indentation on autoindenting

vim.wo.fillchars = "eob: " -- Remove tilde in sidebar

o.shortmess:append "c"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]] -- define how keywords are grouped
vim.cmd [[let g:netrw_winsize = 30]] -- set the size of the netrw window

-- Hightlight yanked text
vim.hl.on_yank({ higroup = "IncSearch", timeout = 400 })
