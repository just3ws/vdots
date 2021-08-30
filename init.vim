if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

" shellescape(fnamemodify('~', ':p'))

call mkdir(stdpath('cache'), 'p')
call mkdir(stdpath('config'), 'p')
call mkdir(stdpath('data'), 'p')

call mkdir(stdpath('data') . '/backup', 'p')
call mkdir(stdpath('data') . '/plugged', 'p')
call mkdir(stdpath('data') . '/shada', 'p')
call mkdir(stdpath('data') . '/swap', 'p')
call mkdir(stdpath('data') . '/undo', 'p')
call mkdir(stdpath('data') . '/view', 'p')

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
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'arcticicestudio/nord-vim'
  Plug 'dense-analysis/ale'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'fatih/vim-go', { 'hook_post_update': ':GoUpdateBinaries' }
  Plug 'junegunn/fzf.vim'
  Plug 'kana/vim-textobj-user'
  Plug 'mhinz/vim-startify'
  Plug 'mileszs/ack.vim'
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'pbrisbin/vim-mkdir'
  Plug 'preservim/nerdtree'
  Plug 'sheerun/vim-polyglot'
  Plug 'sjl/vitality.vim'
  Plug 'tek/vim-textobj-ruby'
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
  Plug 'zchee/deoplete-jedi'
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

let g:ruby_host_prog=$HOME.'/.asdf/shims/neovim-ruby-host'
let g:python_host_prog = $HOME.'/.asdf/shims/python2'
let g:python2_host_prog = $HOME.'/.asdf/shims/python2'
let g:python3_host_prog = $HOME.'/.asdf/shims/python3'

" ' - Maximum number of previously edited files marks
" < - Maximum number of lines saved for each register
" @ - Maximum number of items in the input-line history to be
" s - Maximum size of an item contents in KiB
" h - Disable the effect of 'hlsearch' when loading the shada
set shada='300,<10,@50,s100,h

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

augroup vimrcEx
  autocmd!

  autocmd VimResized * wincmd =

  " When editing a file, always jump to the last known cursor position. Don't
  " do it for commit messages, when the position is invalid, or when inside an
  " event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .mdlrc set filetype=ruby
  autocmd BufRead,BufNewFile .{eslint,npm,prettier}ignore set filetype=gitignore
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint,prettier,release}rc set filetype=json

  autocmd BufEnter * if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree' && winnr('$') > 1 | b# | exe "normal! \<c-w>\<c-w>" | :blast | endif

  " Automatically close corresponding loclist when quitting a window
  autocmd QuitPre * if &filetype != 'qf' | silent! lclose | endif
augroup END

let g:EditorConfig_exclude_patterns = [ 'fugitive://.*', 'scp://.*', ]

set number
set numberwidth=3

" Quote textobj helpers
xmap q iq
omap q iq

let g:ale_shell = '/usr/local/bin/zsh'

let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WRN'
let g:ale_sign_error = 'E'
let g:ale_sign_style_error = 'e'
let g:ale_sign_warning = 'W'
let g:ale_sign_style_warning = 'w'

" let g:ale_linters = { 'ruby': [] }

" let g:ale_fixers = {
"       \   '*': ['remove_trailing_lines', 'trim_whitespace'],
"       \   'yaml': ['remove_trailing_lines', 'trim_whitespace'],
"       \   'ruby': ['remove_trailing_lines', 'trim_whitespace', 'rubocop'],
"       \   'javascript': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
"       \   'css': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
"       \   'json': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
"       \ }

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" com! ALECheckNow     call ale#Queue(0)
" com! ALEShowCommand  echo ale_linters#ruby#rubocop#GetCommand(bufnr('%'))

" When the type of shell script is /bin/sh, assume a POSIX-compatible shell
" for syntax highlighting purposes.
let g:is_posix = 1

set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set nojoinspaces

let g:fzf_history_dir = $FZF_HISTORY_DIR

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full

function! InsertTabWrapper() abort
  let col = col('.') - 1

  if !col || getline('.')[col - 1] !~# '\k'
    return "\<Tab>"
  endif

  return "\<C-p>"
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Swap the case for changing tabs
noremap <S-h> gT
noremap <S-l> gt

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Set tags for vim-fugitive
set tags^=.git/tags

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l


" Always use vertical diffs
set diffopt+=vertical

set clipboard& clipboard+=unnamed,unnamedplus

set ignorecase
set smartcase

" Saner command-line history
cnoremap <C-n> <down>
cnoremap <C-p> <up>

" Double tap to select whole line
nmap <Leader><Leader> V

" Avoid accidentally launching Ex mode
nnoremap Q <nop>

nnoremap <Leader>nf :NERDTreeFind<CR>
nnoremap <Leader>n :NERDTreeFocus<CR>

" Saner block shift
xnoremap < <gv
xnoremap > >gv

" Saner behavior of n and N
nnoremap <expr> N 'nN'[v:searchforward]
nnoremap <expr> n 'Nn'[v:searchforward]

" Saner movement through wrapped lines
nnoremap j gj
nnoremap k gk

" Map Ctrl + p to open fuzzy find (FZF)
" nnoremap <C-p> :FZF<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>

command! Reload :source $MYVIMRC

command! Vimrc  :edit $MYVIMRC
command! Svimrc :split $MYVIMRC
command! Tvimrc :tabedit $MYVIMRC
command! Vvimrc :vsplit $MYVIMRC

command! Zshenv  :edit $ZDOTDIR/.zshenv
command! Szshenv :split $ZDOTDIR/.zshenv
command! Tzshenv :tabedit $ZDOTDIR/.zshenv
command! Vzshenv :vsplit $ZDOTDIR/.zshenv

let g:deoplete#enable_at_startup = 1
