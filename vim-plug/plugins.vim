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

  if exists('g:vscode')
  else

  " Color Schemes
  Plug 'joshdick/onedark.vim'
  Plug 'ghifarit53/tokyonight.vim'
  Plug 'junegunn/seoul256.vim'
  Plug 'rakr/vim-one'
  Plug 'skbolton/embark'
  
  " JavaScript
  Plug 'pangloss/vim-javascript'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

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

  "Buffer line
  Plug 'mengelbrecht/lightline-bufferline'
  
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

  " Obsession
  Plug 'tpope/vim-obsession'
  
  " Tree Sitter
  Plug 'nvim-treesitter/nvim-treesitter'

  "Git Messenger
  Plug 'rhysd/git-messenger.vim'

  "Experimental"
  Plug 'romgrk/todoist.vim', { 'do': ':TodoistInstall' }
  Plug 'justinmk/vim-dirvish'
  Plug 'michal-h21/vim-zettel'
  Plug 'kshenoy/vim-signature'
  Plug 'itchyny/calendar.vim'

endif

call plug#end()


" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

