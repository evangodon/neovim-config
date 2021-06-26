" Hightlight yanked text
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END

set clipboard=unnamedplus          " Copy paste between vim and everything else

set t_Co=256                                                                                      
set termguicolors                                                                                 
set nowrap                                                                                        
syntax on                                                                                         
set guifont=DroidSansMono\ Nerd\ Font:h11 

" General settings
set autoindent               " always set autoindenting on
set copyindent               " copy the previous indentation on autoindenting
set expandtab                " expand tabs by default (overloadable per file type)
set shiftround               " use multiple of shiftwidth when indenting with '<' and '>'
set shiftwidth=2             " number of spaces to use for autoindenting
set hidden                   " required to keep multiple buffers open
set mouse=a                  " Enable the mouse
set colorcolumn=90
filetype plugin on
set noswapfile               " Disable swapfiles
set conceallevel=2

set smartindent
set smarttab " insert tabs on the start of a line according to shiftwidth, not tabstop

set softtabstop=2 " when hitting <BS>, pretend like a tab is removed, even if spaces
set tabstop=2 " tabs are n spaces

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" Setup Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Highlight the current line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#1a1b26 ctermbg=234

" line numbers
set number relativenumber

" Spell Check
"autocmd FileType vimwiki setlocal spell spelllang=en_ca


