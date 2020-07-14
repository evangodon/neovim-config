set noshowmode " hide mode status
set laststatus=2 " always show status line
set showtabline=2 " always show status line

let g:loaded_gitbranch = 1

let s:save_cpo = &cpo
set cpo&vim

augroup GitBranch
  autocmd!
  autocmd BufNewFile,BufReadPost * call gitbranch#detect(expand('<amatch>:p:h'))
  autocmd BufEnter * call gitbranch#detect(expand('%:p:h'))
augroup END

function LightlineObsession()
    return '%{ObsessionStatus()}'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

let g:lightline#bufferline#enable_devicons=1
let g:lightline#bufferline#filename_modifier=':t'
let g:lightline#bufferline#show_number=2

let g:lightline = {
      \ 'colorscheme': g:is_day ? 'one' : 'tokyonight',
      \ 'separator': {'left': " ", 'right': " "},
      \ 'subseparator': {'left': '\\', 'right': '\\'},
      \ 'tabline_separator': { 'left': "", 'right': "" },
      \ 'tabline_subseparator': {'left': '/', 'right': '/'},
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch','cocstatus', 'readonly', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'obsession', 'fileformat', 'fileencoding', 'filetype', 'charvaluehex'  ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['vim_logo'], ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component': {
      \   'vim_logo': "\ue7c5 ",
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name',
      \   'cocstatus': 'coc#status',
      \ },
      \ 'component_expand': {
      \   'obsession': 'LightlineObsession',
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ }

