augroup ft_markdown
  autocmd! * <buffer>
augroup end

setlocal textwidth=80

let g:vim_markdown_autowrite = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_toml_frontmatter = 1

let g:ale_linters.markdown = ['mdl']
let g:ale_fixers.markdown = ['prettier']

let g:vim_markdown_folding_disabled = 1
