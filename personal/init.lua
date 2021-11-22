
-- Migration from vimscript to lua:
--
-- Move all plugins to use packer
--
-- Convert each config file to lua
-- Require the file here
-- [X] settings
-- [X] theme 
-- [X] keys
-- [X] which-key
-- [ ] use packer for all plugins
-- [ ] fzf


config_root = "~/.config/nvim/personal"

require('settings')
require('plugins')
require('keymappings')
require('colortheme')

vim.cmd('source'..config_root..'/vim-plug/plugins.vim')

require('plugin_configs.zen-mode')
require('plugin_configs.toggleterm')
require('plugin_configs.barbar')

-- Plugin configs 
vim.cmd('source'..config_root..'/plug-config/goyo.vim')
vim.cmd('source'..config_root..'/plug-config/lightline.vim')
vim.cmd('source'..config_root..'/plug-config/coc.vim')
vim.cmd('source'..config_root..'/plug-config/vim-wiki.vim')
vim.cmd('source'..config_root..'/plug-config/vim-go.vim')
vim.cmd('source'..config_root..'/plug-config/rnvimr.vim')
vim.cmd('source'..config_root..'/plug-config/fzf.vim')
vim.cmd('source'..config_root..'/plug-config/table-mode.vim')
vim.cmd('source'..config_root..'/plug-config/quickscope.vim')
vim.cmd('source'..config_root..'/plug-config/startify.vim')
vim.cmd('source'..config_root..'/plug-config/floaterm.vim')
vim.cmd('source'..config_root..'/plug-config/todoist.vim')
vim.cmd('source'..config_root..'/plug-config/firenvim.vim')
vim.cmd('source'..config_root..'/plug-config/vim-zettel.vim')
vim.cmd('source'..config_root..'/plug-config/calendar.vim')
vim.cmd('source'..config_root..'/plug-config/dirvish.vim')
