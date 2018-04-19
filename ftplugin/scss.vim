augroup FT_SCSS
  autocmd!
augroup END

packadd vim-jsbeautify

setlocal expandtab
setlocal omnifunc=csscomplete#CompleteCSS
setlocal shiftround
setlocal shiftwidth=2
setlocal smarttab
setlocal softtabstop=2
setlocal tabstop=2

noremap <buffer> <c-f> :call CSSBeautify()<cr>
vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
