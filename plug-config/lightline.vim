set noshowmode " hide mode status
set laststatus=2 " always show status line

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

let g:lightline = {
      \ 'colorscheme': 'tokyonight',
      \ 'separator': {'left': " ", 'right': " "},
      \ 'subseparator': {'left': '', 'right': ''},
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch','cocstatus', 'obsession', 'readonly', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'obsession', 'fileformat', 'fileencoding', 'filetype', 'charvaluehex'  ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name',
      \   'cocstatus': 'coc#status',
      \ },
      \ 'component_expand': {
      \   'obsession': 'LightlineObsession'
      \ },
      \ 'enable': { 'tabline': 0}
      \ }

