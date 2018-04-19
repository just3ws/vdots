augroup FT_CLOJURE
  autocmd!
augroup END

packadd vim-leiningen
packadd vim-classpath
packadd vim-salve
packadd vim-fireplace
packadd vim-cljfmt
packadd vim-clojure-highlight
packadd vim-clojure-static
packadd vim-eastwood
packadd rainbow_parentheses.vim

let g:clojure_align_multiline_strings = 1
let g:clojure_align_subforms = 1

let g:ale_linters.clojure = ['joker']
let g:clj_fmt_autosave = 0

noremap <buffer>  <c-f> :Cljfmt<cr>
vnoremap <buffer>  <c-f> :CljfmtRange<cr>
