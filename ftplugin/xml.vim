augroup ft_xml
  autocmd! * <buffer>
augroup end

setlocal omnifunc=xmlcomplete#CompleteTags

setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4

let g:ale_fixers.xml = ['prettier']
