function! tab#complete() abort
  if strpart(getline('.'), 0, col('.') - 1) =~? '^\s*$'
    return '\<Tab>'
  endif

  if &omnifunc !=? ''
    return '\<C-X>\<C-O>'
  endif

  if &dictionary !=? ''
    return '\<C-K>'
  endif

  return '\<C-N>'
endfunction
