
let g:tokyonight_style = 'storm' " available: night, storm
let g:tokyonight_enable_italic = 1
let g:tokyonight_disable_italic_comment = 1
"Change theme depending on the time of day
let g:is_day = (strftime('%H') % 19) > 7

" Set light and dark colorschemes
let g:day_theme = 'one'
let g:night_theme = 'tokyonight'

if g:is_day 
  set background=light
  colorscheme one
else  
  set background=dark
  colorscheme tokyonight  
  colorscheme embark
endif


" Add colors to jsx
hi tsxTagName guifg=#E06C75
hi tsxCloseTagName guifg=#E06C75
hi tsxCloseString guifg=#F99575
hi tsxCloseTag guifg=#F99575
hi tsxAttributeBraces guifg=#F99575
hi tsxEqual guifg=#F99575
hi tsxAtitrb guifg=#F8BD7F cterm=italic
hi ReactProps guifg=#D19A66

highlight Tabline cterm=none gui=none
highlight TablineSel cterm=none gui=none

