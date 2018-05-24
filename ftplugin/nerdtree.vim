augroup ft_nerdtree
  autocmd! * <buffer>
augroup end

setlocal cursorline
setlocal foldcolumn=0
setlocal nofoldenable
setlocal nolist
setlocal signcolumn=no

let g:NERDChristmasTree = 1
let g:NERDTreeAutoCenter = 1
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowHidden = 0

let g:NERDTreeShowBookmarks = 0
let g:NERDTreeIgnore = [
      \ '\.bzr$',
      \ '\.py[cd]$',
      \ '\.swo$',
      \ '\.swp$',
      \ '\~$',
      \ '^\.git$',
      \ '^\.hg$',
      \ '^\.svn$',
      \ '^coverage$',
      \ '^sandi_meter',
      \ '^tags',
      \ ]
