augroup FT_JSON
  autocmd!
augroup END

packadd vim-jsbeautify

noremap <buffer> <c-f> :call JsonBeautify()<cr>
vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
