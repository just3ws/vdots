" function! themes#best_colors() abort
"   if exists('$TMUX')
"     set t_Co=256
"     return
"   endif
" 
"   if has('termguicolors')
"     set termguicolors
"     return
"   endif
" 
"   set t_Co=256
" endfunction
" 
" function! themes#nord() abort
"   set background=dark
" 
"   call themes#best_colors()
" 
"   let g:nord_uniform_diff_background = 0
"   let g:nord_comment_brightness = 12
"   let g:nord_uniform_status_lines = 0
"   let g:nord_italic = 0
"   let g:nord_italic_comments = 0
" 
"   let g:airline_theme = 'nord'
" 
"   colorscheme nord
" 
"   highlight CursorLineNr ctermfg=0 guifg=white
" endfunction
" 
" function! themes#noir() abort
"   set background=dark
" 
"   call themes#best_colors()
" 
"   colorscheme 256_noir
" endfunction
" 
" function! themes#hybrid() abort
"   set background=dark
" 
"   call themes#best_colors()
" 
"   " let g:hybrid_custom_term_colors = 1
" " let g:hybrid_reduced_contrast = 0
" 
"   let g:airline_theme = 'hybrid'
" 
"   colorscheme hybrid
" endfunction
" 
" function! themes#hybrid_material() abort
"   set background=dark
" 
"   " let g:base16colorspace=256
" 
"   call themes#best_colors()
" 
"   let g:enable_bold_font = 1
"   let g:enable_italic_font = 0
"   let g:hybrid_transparent_background = 0
" 
"   let g:airline_theme = 'hybrid'
" 
"   colorscheme hybrid_material
" endfunction
