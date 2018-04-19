augroup FT_JSX
  autocmd!
augroup END

packadd vim-jsbeautify

noremap <buffer> <c-f> :call JsxBeautify()<cr>
vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
