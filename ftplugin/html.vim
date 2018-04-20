augroup ft_html
  autocmd! * <buffer>
augroup end

packadd vim-jsbeautify

setlocal expandtab
setlocal omnifunc=htmlcomplete#CompleteTags
setlocal shiftround
setlocal shiftwidth=2
setlocal smarttab
setlocal softtabstop=2
setlocal tabstop=2

noremap <buffer> <c-f> :call HtmlBeautify()<cr>
vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
