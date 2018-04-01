function! themes#best_colors()
  if has('termguicolors')
    set termguicolors
  else
    call themes#best_term_colors()
  endif
endfunction

function! themes#best_term_colors()
  set t_Co=256
endfunction

function! themes#nord()
  packadd nord-vim
  call themes#best_colors()

  let g:nord_uniform_diff_background = 0
  let g:nord_comment_brightness = 12
  let g:nord_uniform_status_lines = 0
  let g:nord_italic = 0
  let g:nord_italic_comments = 0
  let g:airline_theme = 'nord'

  colorscheme nord
endfunction

function! themes#blaquemagick()
  packadd blaquemagick.vim
  call themes#best_term_colors()

  let g:airline_theme = 'monochrome'

  colorscheme blaquemagick
endfunction

function! themes#nofrils()
  packadd nofrils
  call themes#best_term_colors()

  let g:nofrils_strbackgrounds = 0
  let g:nofrils_heavylinenumbers = 1
  let g:airline_theme = 'monochrome'

  colorscheme nofrils-dark
endfunction
