augroup vimrc
augroup end

let g:mapleader = ';'
let g:maplocalleader = ';'

set runtimepath+=/usr/local/opt/fzf

lua << EOF
require('plugins')

require('mason').setup()
require('mason-lspconfig').setup()

require('nvim-treesitter.configs').setup {
  ensure_installed = { "bash", "c", "css", "go", "html", "javascript", "json", "lua", "markdown", "python", "ruby", "vim", "vimdoc" },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = { enable = true },
}
EOF

runtime! plugin/sensible.vim

set backupskip=*.log,/tmp/*
set backupext=.bak

set backupdir=$HOME/.local/share/nvim/backup//
set directory=$HOME/.local/share/nvim/swap//
set undodir=$HOME/.local/share/nvim/undo//
set viewdir=$HOME/.local/share/nvim/view//

set shada='300,<10,@50,s100,h

set tags^=.git/tags

set splitbelow
set splitright

set diffopt+=vertical

set clipboard& clipboard+=unnamed,unnamedplus

set ignorecase
set smartcase

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

set termguicolors

set laststatus=2
set noshowmode

set background=dark
colorscheme nord
let g:airline_theme='nord'

nnoremap ; :

set backspace=2   " Backspace deletes like most programs in insert mode
set autowrite     " Automatically :write before running commands
set nowrap

set hlsearch
nnoremap <CR> :nohlsearch<CR><CR>

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

set number
set numberwidth=3

xmap q iq
omap q iq

let g:ale_shell = '/usr/local/bin/zsh'

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

nnoremap <C-p> :GFiles<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <Silent><Leader>l :Buffers<CR>

noremap <S-h> gT
noremap <S-l> gt

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

cnoremap <C-n> <down>
cnoremap <C-p> <up>

nmap <Leader><Leader> V

nnoremap Q <nop>

nnoremap <Leader>ef :NERDTreeFind<CR>
nnoremap <Leader>e :NERDTreeFocus<CR>

xnoremap < <gv
xnoremap > >gv

nnoremap <Expr> N 'nN'[v:searchforward]
nnoremap <Expr> n 'Nn'[v:searchforward]

nnoremap j gj
nnoremap k gk

command! Reload :source $MYVIMRC
command! Vimrc  :edit $MYVIMRC
command! Svimrc :split $MYVIMRC
command! Tvimrc :tabedit $MYVIMRC
command! Vvimrc :vsplit $MYVIMRC
command! Zshenv  :edit $ZDOTDIR/.zshenv
command! Szshenv :split $ZDOTDIR/.zshenv
command! Tzshenv :tabedit $ZDOTDIR/.zshenv
command! Vzshenv :vsplit $ZDOTDIR/.zshenv

let g:NERDTreeIgnore = ['\~$', '^tmp$', '^\.git$', '^log$', '^coverage$', 'Gemfile.lock', '^bin$']

nnoremap <C-p> :GFiles<CR>

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

augroup completion_preview_close
  autocmd!
  if v:version > 703 || v:version == 703 && has('patch598')
    autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
  endif
augroup END

augroup go

  au!
  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>db <Plug>(go-doc-browser)

  au FileType go nmap <leader>r  <Plug>(go-run)
  au FileType go nmap <leader>t  <Plug>(go-test)
  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
  au FileType go nmap <C-g> :GoDecls<cr>
  au FileType go nmap <leader>dr :GoDeclsDir<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
  au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>

augroup END

:call extend(g:ale_linters, {
    \"go": ['golint', 'go vet'], })

let g:loaded_perl_provider = 0
