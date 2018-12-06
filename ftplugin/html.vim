augroup ft_html
  autocmd! * <buffer>
augroup end

setlocal expandtab
setlocal omnifunc=htmlcomplete#CompleteTags
setlocal shiftround
setlocal shiftwidth=4
setlocal smarttab
setlocal softtabstop=4
setlocal tabstop=4

noremap <buffer> <c-f> :call HtmlBeautify()<cr>
vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>

let g:html_dynamic_folds = 1
let g:html_no_pre = 1
let g:html_use_css = 1
let g:html_use_encoding = 'UTF-8'
let g:html_no_rendering = 0 " Don't render italic, bold, links in HTML
let g:html_number_lines = 0 " TOhtml don't show line numbers


let g:ale_fixers.html = ['prettier', 'remove_trailing_lines', 'trim_whitespace']
let g:ale_linters.html = ['htmlhint', 'tidy']

let g:ale_html_tidy_options = '-q -e -language en -utf8 --show-body-only 1'
