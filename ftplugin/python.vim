augroup ft_python
  autocmd! * <buffer>
augroup end

setlocal completeopt-=preview

setlocal omnifunc=pythoncomplete#Complete
let g:jedi#auto_initialization = 1


nnoremap <leader>i :!isort %<CR><CR>
nnoremap <LocalLeader>= :0,$!yapf<CR>


let g:ale_fixers.python = ['autopep8', 'isort']
let g:ale_python_pylint_options = '-rcfile ~/.pylintrc'
let g:ale_python_flake8_args='--ignore=E501'
let g:ale_python_autopep8_options = '-aa'
