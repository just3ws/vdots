augroup ft_jsx
  autocmd! * <buffer>
augroup end

packadd vim-jsbeautify

noremap <buffer> <c-f> :call JsxBeautify()<cr>
vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
