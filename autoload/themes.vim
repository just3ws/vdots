function! themes#best_colors() abort
  if exists('$TMUX')
    set t_Co=256
    return
  endif

  if has('termguicolors')
    set termguicolors
    return
  endif

  set t_Co=256
endfunction

function! themes#nord() abort
  call themes#best_colors()

  let g:nord_uniform_diff_background = 0
  let g:nord_comment_brightness = 12
  let g:nord_uniform_status_lines = 0
  let g:nord_italic = 0
  let g:nord_italic_comments = 0
  let g:airline_theme = 'nord'

  colorscheme nord
endfunction
