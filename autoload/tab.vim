" function! tab#complete() abort
"   if strpart(getline('.'), 0, col('.') - 1) =~? '^\s*$'
"     return "\<Tab>"
"   endif
"
"   if &omnifunc !=? ''
"     return "\<C-x>\<C-o>"
"   endif
"
"   if &dictionary !=? ''
"     return "\<C-k>"
"   endif
"
"   return "\<C-n>"
" endfunction
