
config_root = "~/.config/nvim/configs/personal"

if not vim.g.vscode then

  vim.cmd('source'..config_root..'/vim-plug/plugins.vim')
  vim.cmd('source'..config_root..'/general/settings.vim')
  vim.cmd('source'..config_root..'/general/theme.vim')
  vim.cmd('source'..config_root..'/general/keys.vim')
  
  -- Plugin configs 
  vim.cmd('source'..config_root..'/plug-config/goyo.vim')
  vim.cmd('source'..config_root..'/plug-config/lightline.vim')
  vim.cmd('source'..config_root..'/plug-config/coc.vim')
  vim.cmd('source'..config_root..'/plug-config/vim-wiki.vim')
  vim.cmd('source'..config_root..'/plug-config/nerd-commenter.vim')
  vim.cmd('source'..config_root..'/plug-config/vim-go.vim')
  vim.cmd('source'..config_root..'/plug-config/nvim-colorizer.vim')
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

else

  vim.cmd('source'..config_root..'/vscode/plugins.vim')
  vim.cmd('source'..config_root..'/vscode/keys.vim')
  vim.cmd('source'..config_root..'/vscode/settings.vim')
  vim.cmd('source'..config_root..'/plug-config/quickscope.vim')

end

