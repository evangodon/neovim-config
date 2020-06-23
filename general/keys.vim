if exists('g:vscode')

" Simulate same TAB behavior in VSCode
nmap <Tab> :Tabnext<CR>
nmap <S-Tab> :Tabprev<CR>

else

" set <leader>
let mapleader = "\<Space>" 
let g:maplocalleader = ','



" When going up or down one line, use displayed lines instead of physical lines
noremap silent! <silent> k gk
noremap silent! <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$

" Navigate buffers
nnoremap <silent> <C-N> :bnext<CR>
nnoremap <silent> <C-P> :bprev<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Use alt + hjkl to resize windows
nnoremap <silent> <M-j>    :resize -2<CR>
nnoremap <silent> <M-k>    :resize +2<CR>
nnoremap <silent> <M-h>    :vertical resize -2<CR>
nnoremap <silent> <M-l>    :vertical resize +2<CR>

" Terminal  Mode
tnoremap <Esc> <C-\><C-n>

" Map control-s to write
noremap  <silent> <C-S>  :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
" Mimic control-w from vscode
nnoremap <expr> <C-w> len(getbufinfo({'buflisted':1}))  == 1 ? ':q<cr>':':bd<cr>'


" Map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Better indenting
vnoremap < <gv
vnoremap > >gv

" <TAB>: completion.
inoremap <silent> <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
set timeoutlen=500

" Move selected line / block of text in visual mode
" shift + k to move up
" shift + j to move down
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Toggle comment line
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

" Whick key mappings 
let g:which_key_map['.'] = [ ':e ~/.config/nvim'          , 'open init' ]
let g:which_key_map[';'] = [ ':Commands'                  , 'commands' ]
let g:which_key_map['='] = [ '<C-W>='                     , 'balance windows' ]
let g:which_key_map[','] = [ 'Startify'                   , 'start screen' ]
let g:which_key_map['d'] = [ ':bd'                        , 'delete buffer']
let g:which_key_map['e'] = [ ':CocCommand explorer'       , 'explorer' ]
let g:which_key_map['f'] = [ ':Files'                     , 'search files' ]
let g:which_key_map['r'] = [ ':RnvimrToggle'              , 'toggle ranger' ]
let g:which_key_map['h'] = [ '<C-W>s'                     , 'split below']
let g:which_key_map['q'] = [ ':q!'                        , 'quit' ]
let g:which_key_map['S'] = [ ':SSave'                     , 'save session' ]
let g:which_key_map['v'] = [ '<C-W>v'                     , 'split right']
let g:which_key_map['z'] = [ 'Goyo'                       , 'zen' ]
let g:which_key_map['T'] = [ ':Rg'                        , 'search text' ]
let g:which_key_map['tm'] = [ ':TableModeToggle'          , 'toggle table mode' ]


" Register which key map
call which_key#register('<Space>', "g:which_key_map")

endif
