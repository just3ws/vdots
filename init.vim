if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

filetype on
filetype indent on
filetype plugin on

if !exists('g:syntax_on')
  syntax enable
endif

augroup vimrc
  autocmd! * <buffer>
augroup end

let g:mapleader = ';'
let g:maplocalleader = ';'

set runtimepath+=/usr/local/opt/fzf

call plug#begin(stdpath('data') . '/plugged')
  Plug '/usr/local/opt/fzf'

  Plug 'SirVer/ultisnips'
  Plug 'arcticicestudio/nord-vim'
  Plug 'dense-analysis/ale'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'honza/vim-snippets'
  Plug 'junegunn/fzf.vim'
  Plug 'kana/vim-textobj-user'
  Plug 'mhinz/vim-startify'
  Plug 'mileszs/ack.vim'
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'pbrisbin/vim-mkdir'
  Plug 'preservim/nerdtree'
  Plug 'preservim/tagbar'
  Plug 'sheerun/vim-polyglot'
  Plug 'sjl/vitality.vim'
  Plug 'tek/vim-textobj-ruby'
  Plug 'tmhedberg/matchit'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-bundler'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-git'
  Plug 'tpope/vim-projectionist'
  Plug 'tpope/vim-ragtag'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-rake'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-ruby/vim-ruby'
  Plug 'vim-scripts/align'
  Plug 'vitalk/vim-shebang'
  Plug 'wellle/targets.vim'
call plug#end()

filetype plugin indent on
syntax enable

runtime! plugin/sensible.vim

set backupskip=*.log,/tmp/*
set backupext=.bak

set backupdir=$HOME/.local/share/nvim/backup//
set directory=$HOME/.local/share/nvim/swap//
set undodir=$HOME/.local/share/nvim/undo//
set viewdir=$HOME/.local/share/nvim/view//

" ' - Maximum number of previously edited files marks
" < - Maximum number of lines saved for each register
" @ - Maximum number of items in the input-line history to be
" s - Maximum size of an item contents in KiB
" h - Disable the effect of 'hlsearch' when loading the shada
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

" When the type of shell script is /bin/sh, assume a POSIX-compatible shell
" for syntax highlighting purposes.
let g:is_posix = 1

set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set nojoinspaces

" Write history on idle, for sharing among different sessions
autocmd! vimrc CursorHold * if exists(':rshada') |
      \   rshada |
      \   wshada |
      \ endif

function! s:themes_best_colors() abort
  if exists('$TMUX')
    set t_Co=256
    return
  endif

  if has('termguicolors')
    set termguicolors
    return
  endif

  set t_Co=256
endfunction

set laststatus=2
set noshowmode

set background=dark
call s:themes_best_colors()
colorscheme nord
" highlight Conceal guifg=#616E88 ctermfg=8
let g:airline_theme='nord'

" Convert ; to : in modeline
nnoremap ; :

set backspace=2   " Backspace deletes like most programs in insert mode
set autowrite     " Automatically :write before running commands
set nowrap

set hlsearch
nnoremap <CR> :nohlsearch<CR><CR>

" Incremental everything
set inccommand=

highlight BadWhitespace ctermbg=red guibg=darkred

augroup vimrc
  autocmd!
  autocmd! * <buffer>

  au VimResized * wincmd =

  " When editing a file, always jump to the last known cursor position. Don't
  " do it for commit messages, when the position is invalid, or when inside an
  " event handler (happens when dropping a file on gvim).
  au BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  au BufEnter * if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree' && winnr('$') > 1 | b# | exe "normal! \<c-w>\<c-w>" | :blast | endif

  au BufEnter *.png,*.jpg,*gif exec "! open ".expand("%") | :bw

  " Set syntax highlighting for specific file types
  " au BufRead,BufNewFile *.js   set tabstop=2 set softtabstop=2 set shiftwidth=2
  " au BufRead,BufNewFile *.html set tabstop=2 set softtabstop=2 set shiftwidth=2
  " au BufRead,BufNewFile *.css  set tabstop=2 set softtabstop=2 set shiftwidth=2
  " au BufRead,BufNewFile *.py   set tabstop=4 set softtabstop=4 set shiftwidth=4 set textwidth=79 set expandtab set autoindent set fileformat=unix
  au FileType css,scss,slim,html,eruby,coffee,javascript,wxml setlocal iskeyword+=-
  au Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
  au Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2
  au Filetype markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
  au Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4
  au Filetype ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
  " Set syntax highlighting for specific file types
  au BufRead,BufNewFile *.md set filetype=markdown
  au BufRead,BufNewFile .mdlrc set filetype=ruby
  au BufRead,BufNewFile .env set filetype=shell
  au BufRead,BufNewFile .env.* set filetype=shell
  au BufRead,BufNewFile .erdconfig set filetype=yaml
  au BufRead,BufNewFile .{eslint,npm,prettier}ignore set filetype=gitignore
  au BufRead,BufNewFile .{jscs,jshint,eslint,prettier,release}rc set filetype=json
  au BufNewFile,BufRead *.lst set filetype=txt

  autocmd! vimrc BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

  au BufWritePre * :%s/\s\+$//e
  au BufWritePre * :%s/\n\{3,\}/\r\r/e

  " Automatically close corresponding loclist when quitting a window
  au QuitPre * if &filetype != 'qf' |
        \ silent! lclose |
        \ endif
augroup end

let g:EditorConfig_exclude_patterns = [ 'fugitive://.*', 'scp://.*', ]

set number
set numberwidth=3

" Quote textobj helpers
xmap q iq
omap q iq

let g:ale_shell = '/usr/local/bin/zsh'

" let g:ale_sign_error = 'E'
" let g:ale_sign_warning = 'W'
let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WRN'
let g:ale_sign_error = '●'
let g:ale_sign_style_error = 'e'
let g:ale_sign_style_warning = 'w'
let g:ale_sign_warning = '.'

let g:ale_linters = { 'ruby': ['brakeman', 'rubocop'] }
" ['brakeman', 'debride', 'rails_best_practices', 'reek', 'rubocop', 'ruby', 'solargraph', 'sorbet', 'standardrb']
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

" let g:deoplete#enable_at_startup = 1
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

" set statusline+=%=
" set statusline+=\ %{LinterStatus()}

" com! ALECheckNow     call ale#Queue(0)
" com! ALEShowCommand  echo ale_linters#ruby#rubocop#GetCommand(bufnr('%'))

" let g:fzf_history_dir = $FZF_HISTORY_DIR

" " Default fzf layout
" " - down / up / left / right
" let g:fzf_layout = { 'down': '~40%' }

" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
" let g:fzf_layout = { 'window': '10new' }
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(':Ag')
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Map Ctrl + p to open fuzzy find (FZF)
" nnoremap <C-p> :FZF<CR>
" nnoremap <C-p> :Files<CR>
" Git Files
nnoremap <C-p> :GFiles<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <Silent><Leader>l :Buffers<CR>

" function! InsertTabWrapper() abort
"   let col = col('.') - 1
"
"   if !col || getline('.')[col - 1] !~# '\k'
"     return "\<Tab>"
"   endif
"
"   return "\<C-p>"
" endfunction
" inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
" inoremap <S-Tab> <C-n>

" " Switch between the last two files
" nnoremap <Leader><Leader> <C-^>

" Swap the case for changing tabs
noremap <S-h> gT
noremap <S-l> gt

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Saner command-line history
cnoremap <C-n> <down>
cnoremap <C-p> <up>

" Double tap to select whole line
nmap <Leader><Leader> V

" Avoid accidentally launching Ex mode
nnoremap Q <nop>

nnoremap <Leader>ef :NERDTreeFind<CR>
nnoremap <Leader>e :NERDTreeFocus<CR>

" Saner block shift
xnoremap < <gv
xnoremap > >gv

" Saner behavior of n and N
nnoremap <Expr> N 'nN'[v:searchforward]
nnoremap <Expr> n 'Nn'[v:searchforward]

" Saner movement through wrapped lines
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

nmap <F8> :TagbarToggle<CR>

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<c-b>'
let g:UltiSnipsJumpBackwardTrigger='<c-z>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'
