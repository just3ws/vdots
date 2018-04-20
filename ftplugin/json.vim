augroup ft_json
  autocmd! * <buffer>
augroup end

packadd vim-jsbeautify

noremap <buffer> <c-f> :call JsonBeautify()<cr>
vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
