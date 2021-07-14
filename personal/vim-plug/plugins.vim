" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif


call plug#begin()
"
  " Quickscope
  Plug 'unblevable/quick-scope'


  " Coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " limelight
  Plug 'junegunn/limelight.vim'

  " Nerd Commenter
  Plug 'preservim/nerdcommenter'

  "Buffer line
  Plug 'mengelbrecht/lightline-bufferline'
  
  " Colorizer FIXME
  " Plug 'norcalli/nvim-colorizer.lua'

  " Ranger
  Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

  " fzf
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'"

  " router
  Plug 'airblade/vim-rooter'

  " Table Mode
  Plug 'dhruvasagar/vim-table-mode'

  " Float term
  Plug 'voldikss/vim-floaterm'

  "Firenvim"
   Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

  " Undo tree"
  Plug 'mbbill/undotree'

  " Obsession
  Plug 'tpope/vim-obsession'
  
  " Tree Sitter
  "Plug 'nvim-treesitter/nvim-treesitter'

  "Git Messenger
  Plug 'rhysd/git-messenger.vim'

call plug#end()


" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

