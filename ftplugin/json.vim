augroup ft_json
  autocmd! * <buffer>
augroup end

noremap <buffer> <c-f> :call JsonBeautify()<cr>
vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>

let g:ale_fixers.json = ['prettier']

let g:vim_json_syntax_conceal = 0
