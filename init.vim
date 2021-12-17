" if has('vim_starting')
"   set encoding=utf-8
"   scriptencoding utf-8
" endif

filetype on
filetype indent on
filetype plugin on

if !exists('g:syntax_on')
  syntax enable
endif

let g:mapleader = ';'
let g:maplocalleader = ';'

let g:ruby_host_prog = $HOME.'/.asdf/shims/neovim-ruby-host'
let g:python_host_prog = $HOME.'/.asdf/shims/python2'
let g:python2_host_prog = $HOME.'/.asdf/shims/python2'
let g:python3_host_prog = $HOME.'/.asdf/shims/python3'

"" When the type of shell script is /bin/sh, assume a POSIX-compatible shell
"" for syntax highlighting purposes.
" let g:is_posix = 1

set rtp+=/usr/local/opt/fzf

call plug#begin(stdpath('data') . '/plugged')
Plug 'neovim/nvim-lspconfig'

Plug 'tpope/vim-sensible'
Plug 'sjl/vitality.vim'

Plug 'arcticicestudio/nord-vim'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'mileszs/ack.vim'

Plug 'kana/vim-textobj-user'

Plug 'pbrisbin/vim-mkdir'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/align'

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }  " We recommend updating the parsers on update
Plug 'sheerun/vim-polyglot'
Plug 'vitalk/vim-shebang'
Plug 'wellle/targets.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'airblade/vim-gitgutter'

Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tek/vim-textobj-ruby'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'vim-ruby/vim-ruby'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

filetype plugin indent on
syntax enable

runtime! plugin/sensible.vim

set clipboard& clipboard+=unnamed,unnamedplus
" set diffopt+=vertical
" set wildmode=list:longest,list:full
set autowrite
set autowriteall
set backupext=.bak
set backupskip=*.log
set expandtab
set ignorecase
set inccommand=
set number
set numberwidth=3
set shiftround
set shiftwidth=2
set smartcase
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set tags^=.git/tags
set undofile

set noshowmode
set nowrap

""" Shada
"" ' - Maximum number of previously edited files marks
"" < - Maximum number of lines saved for each register
"" @ - Maximum number of items in the input-line history to be
"" s - Maximum size of an item contents in KiB
"" h - Disable the effect of 'hlsearch' when loading the shada
" set shada='300,<10,@50,s100,h

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

call s:themes_best_colors()
colorscheme nord
let g:airline_theme='nord'

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Quote textobj helpers
xmap q iq
omap q iq

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

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

" Convert ; to : in modeline
nnoremap ; :
nnoremap <CR> :nohlsearch<CR><CR>

command! Reload :source $MYVIMRC

command! Vimrc  :edit $MYVIMRC
command! Svimrc :split $MYVIMRC
command! Tvimrc :tabedit $MYVIMRC
command! Vvimrc :vsplit $MYVIMRC

command! Zshenv  :edit $ZDOTDIR/.zshenv
command! Szshenv :split $ZDOTDIR/.zshenv
command! Tzshenv :tabedit $ZDOTDIR/.zshenv
command! Vzshenv :vsplit $ZDOTDIR/.zshenv

highlight BadWhitespace ctermbg=red guibg=darkred

augroup vimrc
  autocmd!
  autocmd! * <buffer>

  au VimResized * wincmd =

  "" Write history on idle, for sharing among different sessions
  " au CursorHold * if exists(':rshada') |
  "       \   rshada |
  "       \   wshada |
  "       \ endif

  au BufEnter *.png,*.jpg,*gif exec "! open ".expand("%") | :bw

  " Set syntax highlighting for specific file types
  au Filetype markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
  au Filetype ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
  au FileType css,scss,slim,html,eruby,coffee,javascript,wxml setlocal iskeyword+=-
  au Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
  au Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2
  au Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4

  " When editing a file, always jump to the last known cursor position. Don't
  " do it for commit messages, when the position is invalid, or when inside an
  " event handler (happens when dropping a file on gvim).
  au BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  "" Double slash does not actually work for backupdir, here's a fix
  " au BufWritePre * let &backupext='@'.substitute(substitute(substitute(expand('%:p:h'), '/', '%', 'g'), '\', '%', 'g'), ':', '', 'g')

  au BufWritePre * :%s/\s\+$//e
  au BufWritePre * :%s/\n\{3,\}/\r\r/e
  " au BufWritePre * gg=G<C-o><C-o>

  " Automatically close corresponding loclist when quitting a window
  au QuitPre * if &filetype != 'qf' |
        \ silent! lclose |
        \ endif
augroup end

let g:NERDTreeIgnore = [
      \ '\~$',
      \ '^tmp$',
      \ '^\.git$',
      \ '^log$',
      \ '^coverage$',
      \ 'Gemfile.lock',
      \ '^bin$'
      \ ]

nnoremap <C-p> :GFiles<CR>
