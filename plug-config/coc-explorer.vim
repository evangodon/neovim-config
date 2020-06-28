
nnoremap <space>e :CocCommand explorer<CR>

let g:coc_global_extensions = [
	\ 'coc-css',
  \ 'coc-cssmodules',
	\ 'coc-eslint',
	\ 'coc-git',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-snippets',
	\ 'coc-tsserver',
\ ]



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
