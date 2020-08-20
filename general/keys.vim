
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

" Navigate to beginning or ending of line
nnoremap H 0
nnoremap L $
vnoremap H 0
vnoremap L $


nnoremap <silent> <C-h> <C-w><C-h><CR>
nnoremap <silent> <C-j> <C-w><C-j><CR>
nnoremap <silent> <C-k> <C-w><C-k><CR>
nnoremap <silent> <C-l> <C-w><C-l><CR>

" Use alt + hjkl to resize windows
nnoremap <silent> <M-j>    :resize -2<CR>
nnoremap <silent> <M-k>    :resize +2<CR>
nnoremap <silent> <M-h>    :vertical resize -2<CR>
nnoremap <silent> <M-l>    :vertical resize +2<CR>

" Navigate buffers
nnoremap <silent> [b       :bprevious<CR>
nnoremap <silent> ]b       :bnext<CR>
nnoremap <silent> [B       :bfirst<CR>
nnoremap <silent> ]B       :blast<CR>

" Terminal  Mode
tnoremap <Esc> <C-\><C-n>

" Map control-s to write
noremap  <silent> <C-S>  :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>



" Map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Better indenting
vnoremap < <gv
vnoremap > >gv

" <TAB>: completion.
inoremap <silent> <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" up/down mapped to ctrl{j,k}
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

nnoremap <silent> gh :call <SID>show_documentation()<CR>

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
set timeoutlen=300

" Move selected line / block of text in visual mode
" shift + k to move up
"shift + j to move down
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Toggle comment line
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv
" todo: need to fix this
nnoremap <leader>c   <Plug>NERDCommenterAltDelims<CR>

" Bufferline
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" Fzf
map <C-f> :BLines<CR>
map <C-P> :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader><Enter> :FloatermToggle <CR>
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
nnoremap <leader>q :q<CR>
nnoremap <leader>d :bd<CR>

"nnoremap <expr> <leader>w len(getbufinfo({'buflisted':1}))  == 1 ? ':q<cr>':':bd<cr>'

" Which key mappings 
let g:which_key_map['.'] = [ ':e $MYVIMRC'                , 'open init' ]
let g:which_key_map[';'] = [ ':Commands'                  , 'commands' ]
let g:which_key_map[','] = [ 'Startify'                   , 'start screen' ]
let g:which_key_map["'"] = [ ':Marks'                     , 'search marks' ]
let g:which_key_map['e'] = [ ':CocCommand explorer'       , 'explorer' ]
let g:which_key_map['B'] = [ ':Buffers'                   , 'view Buffers' ]
let g:which_key_map['f'] = [ ':BLines'                    , 'search in buffer' ]
let g:which_key_map['r'] = [ ':RnvimrToggle'              , 'toggle ranger' ]
let g:which_key_map['S'] = [ ':SSave'                     , 'save session' ]
let g:which_key_map['Z'] = [ 'Goyo'                       , 'zen' ]
let g:which_key_map['T'] = [ ':Todoist'                   , 'search text' ]
let g:which_key_map['u'] = [ ':UndotreeToggle'            , 'toggle undo tree' ]
let g:which_key_map['O'] = [ ':Obsess'                    , 'toggle obsession state' ]
let g:which_key_map['G'] = [ ':FloatermNew lazygit'       , 'open lazygit' ]
let g:which_key_map['C'] = [ ':Calendar -view=day'        , 'open day Calendar' ]
let g:which_key_map['tm'] = [ ':TableModeToggle'          , 'toggle table mode' ]


let g:which_key_map.b = {
      \ 'name' : '+buffers' ,
      \ 'd' : [':bd'                                      , 'delete'],
      \ }

let g:which_key_map.w = {
      \ 'name' : '+windows' ,
      \ 'h' : [':wincmd v'                                      , 'delete'],
      \ 'j' : [':wincmd s'                                      , 'delete'],
      \ 'k' : [':wincmd s'                                      , 'delete'],
      \ 'l' : [':wincmd v'                                      , 'delete'],
      \ }

let g:which_key_map.s = {
      \ 'name' : '+search' ,
      \ 'b' : [':Buffers'                                 , 'buffers'],
      \ 't' : [':Rg'                                      , 'text'],
      \ }

let g:which_key_map.t = {
      \ 'name' : '+terminal' ,
      \ ';' : [':FloatermNew --wintype=popup --height=6'        , 'terminal'],
      \ 'd' : [':FloatermNew lazydocker'                        , 'docker'],
      \ 'n' : [':FloatermNew node'                              , 'node'],
      \ 't' : [':FloatermToggle'                                , 'toggle'],
      \ 'y' : [':FloatermNew ytop'                              , 'ytop'],
      \ 's' : [':FloatermNew ncdu'                              , 'ncdu'],
      \ }

let g:which_key_map.z = {
      \ 'name' : '+vim-zettel' ,
      \ 'b' : [':ZettelBackLinks'                               , 'Generate backlinks'],
      \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")

