augroup ft_go
  autocmd! * <buffer>
augroup end

let $GINKGO_EDITOR_INTEGRATION = "true"

compiler go

setlocal omnifunc=gocomplete#Complete
setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal autowrite

let g:go_addtags_transform = 'snakecase'
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_fmt_command = 'goimports'
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function = 1
let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_return = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1
let g:go_snippet_engine = 'neosnippet'

let g:ale_linters.go = [] " 'golint', 'go vet']
let g:ale_fixers.go = [] " 'gofmt', 'goimports']

nnoremap gs <Plug>(go-def-split)

nmap <Leader>r  <Plug>(go-run)
nmap <Leader>b  <Plug>(go-build)
nmap <Leader>gt :GoDeclsDir<CR>

" highlight! goStdlibErr        gui=Bold    guifg=#ff005f    guibg=None
" highlight! goString           gui=None    guifg=#92999f    guibg=None
" highlight! goComment          gui=None    guifg=#787f86    guibg=None
" highlight! goField            gui=Bold    guifg=#a1cbc5    guibg=None
highlight! link               goStdlib          Statement
highlight! link               goStdlibReturn    PreProc
highlight! link               goImportedPkg     Statement
highlight! link               goFormatSpecifier PreProc
