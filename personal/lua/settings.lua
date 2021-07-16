vim.o.termguicolors = true -- set term gui colors 
vim.o.fileencoding = "utf-8" -- The encoding written to file
vim.o.guifont = "FiraCode Nerd Font:h17"
vim.bo.smartindent = true -- Makes indenting smart
vim.bo.copyindent = true -- copy the previous indentation on autoindenting


vim.wo.number = true -- set numbered lines
vim.wo.relativenumber = true -- set relative number

vim.wo.cursorline = true -- set highlighting of the current line
vim.o.showtabline = 2 -- Always show tabs

vim.o.showmode = false -- Hide the -- INSERT -- in tab

vim.o.swapfile = false -- Do not write any swp files

vim.o.clipboard = "unnamedplus" -- Copy paste between vim and everything else

vim.cmd('set ts=4') -- Insert 2 spaces for a tab
vim.cmd('set sw=4') -- Change the number of space characters inserted for indentation
vim.cmd('set expandtab') -- Converts tabs to spaces

vim.o.mouse = "a" -- Enable mouse

vim.o.hidden = true -- Required to keep multiple buffers open multiple buffers

vim.o.foldenable = false -- Disable folding

vim.wo.signcolumn = "yes" -- Always show the signcolumn, otherwise the text shifts

vim.wo.fillchars = 'eob: ' -- Remove tilde in sidebar

-- Hightlight yanked text
vim.cmd(' \z
  augroup highlight_yank \z
      autocmd! \z
      au TextYankPost * silent! lua vim.highlight.on_yank { higroup=\'IncSearch\', timeout=200 } \z
  augroup END \z
')

