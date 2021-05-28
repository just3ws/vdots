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
  Plug 'ap/vim-buftabline'
  Plug 'arcticicestudio/nord-vim'
  Plug 'beloglazov/vim-textobj-quotes'
  Plug 'christoomey/vim-run-interactive'
  Plug 'dense-analysis/ale'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'fatih/vim-go', { 'hook_post_update': ':GoUpdateBinaries' }
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/fzf.vim'
  Plug 'kana/vim-textobj-user'
  Plug 'mhinz/vim-startify'
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'pbrisbin/vim-mkdir'
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
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
  Plug 'vim-ruby/vim-ruby'
  Plug 'vim-scripts/align'
  Plug 'vim-test/vim-test'
  Plug 'vitalk/vim-shebang'
  Plug 'wellle/targets.vim'
call plug#end()

filetype plugin indent on
syntax enable

runtime! plugin/sensible.vim

if has('nvim')
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
endif

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
highlight Conceal guifg=#616E88 ctermfg=8
let g:lightline = { 'colorscheme': 'nord' }

" Convert ; to : in modeline
nnoremap ; :

nnoremap <leader>ri :RunInInteractiveShell<space>

set backspace=2   " Backspace deletes like most programs in insert mode
set autowrite     " Automatically :write before running commands
set nowrap

" set backupdir=stdpath('data').'/nvim/backup'
set backupdir=$XDG_DATA_HOME/nvim/backup 
set directory=$XDG_DATA_HOME/nvim/tmp

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
  autocmd BufRead,BufNewFile .{eslint,npm,prettier}ignore set filetype=gitignore
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint,prettier,release}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim

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

" Move between linting errors
nmap <silent> <Leader>aj :ALENext<cr>
nmap <silent> <Leader>ak :ALEPrevious<cr>

" let g:ale_enabled = 1

" let g:ale_shell = '/usr/local/bin/zsh'

let g:ale_change_sign_column_color = 1
let g:ale_completion_enabled = 1

let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WRN'
let g:ale_sign_error = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
let g:ale_sign_warning = ''

" let g:airline#extensions#ale#enabled = 1

let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'ruby': ['remove_trailing_lines', 'trim_whitespace', 'rubocop'],
      \   'javascript': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \   'css': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \   'json': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \ }

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Use one space, not two, after punctuation.
set nojoinspaces

let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1

let g:WebDevIconsOS = 'Darwin'

let g:fzf_history_dir = $FZF_HISTORY_DIR

" let g:fzf_layout = { 'window': 'new' }
" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" " Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
" if executable('ag')
"   " Use Ag over Grep
"   set grepprg=ag\ --nogroup\ --nocolor
" 
"   " Use ag in fzf for listing files. Lightning fast and respects .gitignore
"   let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'
" 
"   if !exists(':Ag')
"     command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
"     nnoremap \ :Ag<SPACE>
"   endif
" endif

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

" Saner movement through wrapped lines
nnoremap j gj
nnoremap k gk

" Swap the case for changing tabs
noremap <S-l> gt
noremap <S-h> gT

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

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

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>

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

" Swap the case for changing tabs
noremap <S-l> gt
noremap <S-h> gT

nnoremap <C-p> :FZF<CR>
nnoremap <C-b> :Buffers<CR>


" :TestNearest	In a test file runs the test nearest to the cursor, otherwise
" runs the last nearest test. In test frameworks that don't support line
" numbers it will polyfill this functionality with regexes.
nmap <silent> t<C-n> :TestNearest<CR>
" :TestFile	In a test file runs all tests in the current file, otherwise runs
" the last file tests.
nmap <silent> t<C-f> :TestFile<CR>
" :TestSuite	Runs the whole test suite (if the current file is a test file,
" runs that framework's test suite, otherwise determines the test framework
" from the last run test).
nmap <silent> t<C-s> :TestSuite<CR>
" :TestLast	Runs the last test.
nmap <silent> t<C-l> :TestLast<CR>
" :TestVisit	Visits the test file from which you last run your tests (useful
" when you're trying to make a test pass, and you dive deep into application
" code and close your test buffer to make more space, and once you've made it
" pass you want to go back to the test file to write more tests).
nmap <silent> t<C-g> :TestVisit<CR>
