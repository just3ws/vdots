setlocal omnifunc=rubycomplete#Complete

setlocal iskeyword+=!
setlocal iskeyword+=?
setlocal iskeyword+=:

setlocal smarttab
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal shiftround

let g:ruby_fold = 1
let g:ruby_foldable_groups = 'if def do begin case for {  [ % string # << __END__'
let g:ruby_minlines = 1000
let g:ruby_operators = 1
let g:ruby_space_errors = 1
let g:ruby_spellcheck_strings = 0

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_include_object = 1
let g:rubycomplete_include_objectspace = 1
let g:rubycomplete_load_gemfile = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_rails_proactive = 1
let g:rubycomplete_use_bundler = 1

let g:ruby_heredoc_syntax_filetypes = {
      \ 'xml': { 'start' : 'XML' },
      \ 'html': { 'start' : 'HTML' },
      \ 'eruby': { 'start' : 'ERB' },
      \ 'pgsql': { 'start' : 'SQL' }
      \ }
