function! tab#complete()
    if strpart(getline('.'), 0, col('.') - 1) =~? '^\s*$'
        return "\<Tab>"
    else
        if &omnifunc !=? ''
            return "\<C-X>\<C-O>"
        elseif &dictionary !=? ''
            return "\<C-K>"
        else
            return "\<C-N>"
        endif
    endif
endfunction
