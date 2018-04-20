augroup ft_clojure
  autocmd! * <buffer>
augroup end

let $CLASSPATH_CACHE_DIR = file_utils#init_app_dir('/classpath/cache')
let g:classpath_cache = $CLASSPATH_CACHE_DIR

packadd vim-classpath
packadd vim-salve
packadd vim-fireplace
packadd vim-leiningen
packadd vim-cljfmt
packadd vim-eastwood
packadd vim-clojure-highlight
packadd vim-clojure-static
" packadd rainbow_parentheses.vim

let g:clojure_align_multiline_strings = 1
let g:clojure_align_subforms = 1

let g:ale_linters.clojure = ['joker']
let g:ale_fixers.clojure = [
      \ 'remove_trailing_lines',
      \ 'trim_whitespace',
      \ ]

let g:clj_fmt_autosave = 0

noremap <buffer>  <c-f> :Cljfmt<cr>
vnoremap <buffer>  <c-f> :CljfmtRange<cr>
