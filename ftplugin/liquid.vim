augroup ft_liquid
  autocmd! * <buffer>
augroup end

setlocal expandtab
setlocal shiftround
setlocal shiftwidth=2
setlocal smarttab
setlocal softtabstop=2
setlocal tabstop=2

let g:html_dynamic_folds = 1
let g:html_no_pre = 1
let g:html_use_css = 1
let g:html_use_encoding = 'UTF-8'
let g:html_no_rendering = 0 " Don't render italic, bold, links in HTML
let g:html_number_lines = 0 " TOhtml don't show line numbers


let g:ale_fixers.liquid= ['remove_trailing_lines', 'trim_whitespace']
let g:ale_linters.liquid = ['htmlhint', 'tidy']
let g:ale_html_tidy_options = '-q -e -language en -utf8 --show-body-only 1'
