if exists('g:vscode')

  " Simulate same TAB behavior in VSCode
  nmap <Tab> :Tabnext<CR>
  nmap <S-Tab> :Tabprev<CR>

  nmap <Space>bd :q<CR>
  map <C-c>  y<CR>   

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

  " Window navigation and easy create
  function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
  endfunction

  nnoremap <silent> <C-j> :call WinMove('j')<CR>
  nnoremap <silent> <C-h> :call WinMove('h')<CR>
  nnoremap <silent> <C-k> :call WinMove('k')<CR>
  nnoremap <silent> <C-l> :call WinMove('l')<CR>

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

  " Use K to show documentation in preview window
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

  " Fzf
  map <C-f> :Files<CR>
  nnoremap <leader>g :Rg<CR>
  nnoremap <leader>m :Marks<CR>
  nnoremap <leader>q :q<CR>
  nnoremap <leader><Enter> :FloatermToggle <CR>
  nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

  " Mimic control-w from vscode
  nnoremap <expr> <leader>w len(getbufinfo({'buflisted':1}))  == 1 ? ':q<cr>':':bd<cr>'

  " Which key mappings 
  let g:which_key_map['.'] = [ ':e $MYVIMRC'                , 'open init' ]
  let g:which_key_map[';'] = [ ':Commands'                  , 'commands' ]
  let g:which_key_map[','] = [ 'Startify'                   , 'start screen' ]
  let g:which_key_map["'"] = [ ':Marks'                     , 'search marks' ]
  let g:which_key_map['e'] = [ ':CocCommand explorer'       , 'explorer' ]
  let g:which_key_map['f'] = [ ':GFiles'                    , 'search files' ]
  let g:which_key_map['r'] = [ ':RnvimrToggle'              , 'toggle ranger' ]
  let g:which_key_map['S'] = [ ':SSave'                     , 'save session' ]
  let g:which_key_map['z'] = [ 'Goyo'                       , 'zen' ]
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


  " Register which key map
  call which_key#register('<Space>', "g:which_key_map")

endif
