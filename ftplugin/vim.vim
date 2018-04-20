augroup ft_vim
  autocmd! * <buffer>
augroup end

packadd deoplete.nvim
packadd neco-vim

setlocal expandtab
setlocal foldmethod=marker
setlocal shiftround
setlocal shiftwidth=2
setlocal smarttab
setlocal softtabstop=2
setlocal tabstop=2

let g:deoplete#enable_at_startup = 0
call deoplete#enable()

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()

function! s:check_back_space() abort
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1]  =~? '\s'
endfunction

let g:ale_linters.vim = ['vint']
let g:ale_fixers.vim = ['remove_trailing_lines', 'trim_whitespace']
