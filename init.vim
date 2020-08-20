"    _ __   ___  _____   _(_)_ __ ___
"   | '' \ / _ \/ _ \ \ / / | ''_ ` _ \
"   | | | |  __/ (_) \ V /| | | | | | |
"   |_| |_|\___|\___/ \_/ |_|_| |_| |_|
"
"
" Useful commands:
" :so % - reload config
"
"
" Links:
" https://github.com/aswathkk/dotfiles/blob/master/nvim/init.vim
" https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode
"
if exists('g:vscode')

  source $HOME/.config/nvim/vscode/plugins.vim
  source $HOME/.config/nvim/vscode/keys.vim
  source $HOME/.config/nvim/vscode/settings.vim
  source $HOME/.config/nvim/plug-config/quickscope.vim

else

  source $HOME/.config/nvim/vim-plug/plugins.vim
  source $HOME/.config/nvim/general/settings.vim
  source $HOME/.config/nvim/general/keys.vim
  source $HOME/.config/nvim/general/theme.vim

  "Config for plugins
  source $HOME/.config/nvim/plug-config/goyo.vim
  source $HOME/.config/nvim/plug-config/lightline.vim
  source $HOME/.config/nvim/plug-config/coc.vim
  source $HOME/.config/nvim/plug-config/vim-wiki.vim
  source $HOME/.config/nvim/plug-config/nerd-commenter.vim
  source $HOME/.config/nvim/plug-config/vim-go.vim
  source $HOME/.config/nvim/plug-config/nvim-colorizer.vim
  source $HOME/.config/nvim/plug-config/rnvimr.vim
  source $HOME/.config/nvim/plug-config/fzf.vim
  source $HOME/.config/nvim/plug-config/table-mode.vim
  source $HOME/.config/nvim/plug-config/quickscope.vim
  source $HOME/.config/nvim/plug-config/startify.vim
  source $HOME/.config/nvim/plug-config/floaterm.vim
  source $HOME/.config/nvim/plug-config/todoist.vim
  source $HOME/.config/nvim/plug-config/firenvim.vim
  source $HOME/.config/nvim/plug-config/vim-zettel.vim
  source $HOME/.config/nvim/plug-config/calendar.vim
  source $HOME/.config/nvim/plug-config/dirvish.vim
  "source $HOME/.config/nvim/plug-config/tree-sitter.vim


  " Get Google Calendar credentials
  source $HOME/.cache/calendar.vim/credentials.vim

endif
