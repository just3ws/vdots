augroup ft_javascript
  autocmd! * <buffer>
augroup end

" setlocal omnifunc=tern#Complete
setlocal expandtab
setlocal include=require(
setlocal omnifunc=javascriptcomplete#CompleteJS
setlocal shiftround
setlocal shiftwidth=2
setlocal smarttab
setlocal softtabstop=2
setlocal suffixesadd=.js
setlocal tabstop=2
setlocal foldmethod=syntax

let g:ale_fixers.javascript = ['prettier']
let g:ale_linters.javascript = ['prettier']

let g:ale_javascript_prettier_use_local_config = 1

noremap <Buffer>  <C-f> :call JsBeautify()<cr>
vnoremap <Buffer>  <C-f> :call RangeJsBeautify()<cr>

let g:jsx_ext_required = 1
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
