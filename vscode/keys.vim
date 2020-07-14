
" Navigate to beginning or ending of line
nnoremap H 0
nnoremap L $
vnoremap H 0
vnoremap L $

" When going up or down one line, use displayed lines instead of physical lines
noremap silent! <silent> k gk
noremap silent! <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$

" Close a tab
nmap <Space>d :q<CR>
