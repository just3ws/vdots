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
EOF

" runtime! plugin/sensible.vim

set backupskip=*.log,/tmp/*
set backupext=.bak

set backupdir=$HOME/.local/share/nvim/backup//
set directory=$HOME/.local/share/nvim/swap//
set undodir=$HOME/.local/share/nvim/undo//
set viewdir=$HOME/.local/share/nvim/view//

set shada='300,<10,@50,s100,h

set tags^=.git/tags

set diffopt+=vertical

set wildmode=list:longest,list:full

let g:ruby_host_prog=$HOME.'/.asdf/shims/neovim-ruby-host'
let g:python_host_prog = $HOME.'/.asdf/shims/python2'
let g:python2_host_prog = $HOME.'/.asdf/shims/python2'
let g:python3_host_prog = $HOME.'/.asdf/shims/python3'

let g:is_posix = 1

set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set nojoinspaces

set laststatus=2
set noshowmode

set background=dark
colorscheme nord
let g:airline_theme='nord'

set autowrite " Automatically :write before running commands
set nowrap

set hlsearch

set inccommand=

highlight BadWhitespace ctermbg=red guibg=darkred

augroup vimrc
  autocmd!
  autocmd CursorHold * if exists(':rshada') |
        \   rshada |
        \   wshada |
        \ endif

  au VimResized * wincmd =

  au BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  au BufEnter * if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree' && winnr('$') > 1 | b# | exe "normal! \<c-w>\<c-w>" | :blast | endif

  au BufEnter *.png,*.jpg,*gif exec "! open ".expand("%") | :bw

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

  autocmd vimrc BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

  autocmd BufWritePre * :%s/\s\+$//e
  autocmd BufWritePre * :%s/\n\{3,\}/\r\r/e

  au QuitPre * if &filetype != 'qf' |
        \ silent! lclose |
        \ endif
augroup end

let g:EditorConfig_exclude_patterns = [ 'fugitive://.*', 'scp://.*', ]

xmap q iq
omap q iq

" let g:ale_shell = '/usr/local/bin/zsh'
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

let g:NERDTreeIgnore = ['\~$', '^tmp$', '^\.git$', '^log$', '^coverage$', 'Gemfile.lock', '^bin$']

let g:loaded_perl_provider = 0
