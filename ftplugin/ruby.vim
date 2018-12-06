augroup ft_ruby
  autocmd! * <buffer>
augroup end

compiler ruby

setlocal iskeyword+=!
setlocal iskeyword+=:
setlocal iskeyword+=?
setlocal omnifunc=rubycomplete#Complete

setlocal expandtab
setlocal shiftround
setlocal shiftwidth=2
setlocal smarttab
setlocal softtabstop=2
setlocal tabstop=2

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

" let g:ruby_heredoc_syntax_filetypes = {
"       \ 'xml': { 'start' : 'XML' },
"       \ 'html': { 'start' : 'HTML' },
"       \ 'eruby': { 'start' : 'ERB' },
"       \ 'pgsql': { 'start' : 'SQL' }
"       \ }

let g:ale_linters.ruby = ['rubocop', 'ruby']
let g:ale_fixers.ruby = ['rubocop']

" highlight! rubyClassVariable term=bold cterm=reverse ctermfg=1 gui=reverse guifg=#BF616A guibg=#2E3440
" highlight! rubyGlobalVariable term=bold cterm=reverse ctermfg=1 gui=reverse guifg=#BF616A guibg=#2E3440
" highlight! rubyInterpolation term=bold cterm=reverse ctermfg=1 gui=reverse guifg=#BF616A guibg=#2E3440

let g:tagbar_type_ruby = {
      \   'kinds': [
      \     'm:modules',
      \     'c:classes',
      \     'd:describes',
      \     'C:contexts',
      \     'f:methods',
      \     'F:singleton methods'
      \   ]
      \ }
if executable('ripper-tags')
  let g:tagbar_type_ruby = {
        \   'kinds': [
        \     'm:modules',
        \     'c:classes',
        \     'C:constants',
        \     'F:singleton methods',
        \     'f:methods',
        \     'a:aliases'
        \   ],
        \   'kind2scope': { 'c': 'class', 'm': 'class' },
        \   'scope2kind': { 'class': 'c' },
        \   'ctagsbin': 'ripper-tags',
        \   'ctagsargs': ['-f', '-']
        \ }

endif

" imap <S-CR> <CR><CR>end<Esc>-cc

" Update Hash syntax from `:foo => 1` to `foo: 1`
nnoremap <Leader>: :%s/:\([^ ]*\)\(\s*\)=>/\1:/gc<CR>
