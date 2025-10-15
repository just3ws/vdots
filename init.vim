augroup vimrc
augroup end

" set runtimepath+=/usr/local/opt/fzf

lua << EOF
-- Detect Homebrew prefix based on architecture
local brew_prefix = vim.fn.has('mac') == 1 and
  (vim.fn.isdirectory('/opt/homebrew') == 1 and '/opt/homebrew' or '/usr/local') or ''

-- Update runtimepath dynamically for fzf or other Homebrew packages
vim.opt.runtimepath:append(brew_prefix .. '/opt/fzf')

require('plugins')
require('keymaps')
require('lsp')
require('treesitter')
require('options')
require('settings')
require('nvimtree')
EOF

set tags^=.git/tags

set background=dark
colorscheme nord
let g:airline_theme='nord'

highlight BadWhitespace ctermbg=red guibg=darkred

augroup vimrc
  autocmd!
  autocmd VimResized * wincmd =
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
  autocmd BufEnter *.png,*.jpg,*gif exec "! open ".expand("%") | :bw
  autocmd FileType css,scss,slim,html,eruby,coffee,javascript,wxml setlocal iskeyword+=-
  autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .mdlrc set filetype=ruby
  autocmd BufRead,BufNewFile .env set filetype=shell
  autocmd BufRead,BufNewFile *.bpmn set filetype=xml
  autocmd BufRead,BufNewFile .env.* set filetype=shell
  autocmd BufRead,BufNewFile .erdconfig set filetype=yaml
  autocmd BufRead,BufNewFile .{eslint,npm,prettier}ignore set filetype=gitignore
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint,prettier,release}rc set filetype=json
  autocmd BufNewFile,BufRead *.lst set filetype=txt
  autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
  autocmd BufWritePre * :%s/\s\+$//e
  autocmd BufWritePre * :%s/\n\{3,\}/\r\r/e

  autocmd QuitPre * if &filetype != 'qf' |
        \ silent! lclose |
        \ endif
augroup end

lua << EOF
if vim.fn.has('mac') == 1 then
  local brew_prefix = vim.fn.isdirectory('/opt/homebrew') == 1 and '/opt/homebrew' or '/usr/local'
  vim.g.ale_shell = brew_prefix .. '/bin/zsh'
end
EOF

let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WRN'
let g:ale_sign_error = '●'
let g:ale_sign_style_error = 'e'
let g:ale_sign_style_warning = 'w'
let g:ale_sign_warning = '.'

let g:ale_linters = { 'ruby': ['brakeman', 'rubocop'] }
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'yaml': ['remove_trailing_lines', 'trim_whitespace'],
      \   'ruby': ['remove_trailing_lines', 'trim_whitespace', 'rubocop'],
      \   'javascript': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \   'css': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \   'json': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \ }

let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1

let g:html_indent_tags = 'li\|p'
let python_highlight_all=1

nmap <silent> <C-e> <Plug>(ale_next_wrap)

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_warnings = l:counts.total - l:all_errors

    let l:errors_recap = l:all_errors == 0 ? '' : printf('%d⨉ ', all_errors)
    let l:warnings_recap = l:all_warnings == 0 ? '' : printf('%d⚠ ', all_warnings)
    return (errors_recap . warnings_recap)
endfunction

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor

  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(':Ag')
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif
