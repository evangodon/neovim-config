" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif


call plug#begin()
"
  " Quickscope
  Plug 'unblevable/quick-scope'

  if exists('g:vscode')
  else
  " Color Schemes
  Plug 'dikiaap/minimalist'
  Plug 'joshdick/onedark.vim'
  Plug 'bluz71/vim-nightfly-guicolors'
  Plug 'bluz71/vim-nightfly-guicolors'
  Plug 'artanikin/vim-synthwave84'
  Plug 'ghifarit53/tokyonight.vim'
  Plug 'junegunn/seoul256.vim'
  Plug 'rakr/vim-one'
  
  " JavaScript
  Plug 'pangloss/vim-javascript'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

  " Golang
  "Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

  " Coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Lightline
  Plug 'itchyny/lightline.vim'

  " Startify
  Plug 'mhinz/vim-startify'

  " Wiki
  Plug 'vimwiki/vimwiki'

  " Devicons
  Plug 'ryanoasis/vim-devicons'

  " Move lines
  Plug 'matze/vim-move'

  " Goyo
  Plug 'junegunn/goyo.vim'

  " limelight
  Plug 'junegunn/limelight.vim'

  " Which key"
  Plug 'liuchengxu/vim-which-key'

  " Nerd Commenter
  Plug 'preservim/nerdcommenter'

  "Buftabline
  Plug 'pacha/vem-tabline'
  
  " Colorizer
  Plug 'norcalli/nvim-colorizer.lua'

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
  "
  "Experimental"
  Plug 'romgrk/todoist.vim', { 'do': ':TodoistInstall' }
  Plug 'justinmk/vim-dirvish'

  Plug 'michal-h21/vim-zettel'


endif

call plug#end()


" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

