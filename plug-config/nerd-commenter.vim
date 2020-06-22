
if !exists('g:vscode')
  nnoremap <C-_>   <Plug>NERDCommenterToggle
  vnoremap <C-_>   <Plug>NERDCommenterToggle<CR>

  " Fix comments for jsx
  let g:NERDCustomDelimiters={
	  \ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
  \}
endif
