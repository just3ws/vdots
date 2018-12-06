augroup ft_vim
  autocmd! * <buffer>
augroup end

setlocal expandtab
setlocal foldmethod=marker
setlocal smarttab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

let g:ale_linters.vim = ['vint']
let g:ale_fixers.vim = ['remove_trailing_lines', 'trim_whitespace']
