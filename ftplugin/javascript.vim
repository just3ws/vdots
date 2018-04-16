" setlocal omnifunc=tern#Complete
setlocal expandtab
setlocal omnifunc=javascriptcomplete#CompleteJS
setlocal shiftround
setlocal shiftwidth=2
setlocal smarttab
setlocal softtabstop=2
setlocal tabstop=2

let g:ale_javascript_prettier_use_local_config = 1

noremap <buffer>  <c-f> :call JsBeautify()<cr>
vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
