" Essential settings
if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

filetype on
filetype plugin on
filetype plugin indent on
syntax enable

" Essential plugins using vim-plug
call plug#begin(stdpath('data') . '/plugged')
  Plug '/usr/local/opt/fzf'

  Plug 'arcticicestudio/nord-vim'
  Plug 'dense-analysis/ale'
  Plug 'editorconfig/editorconfig-vim'
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
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-ruby/vim-ruby'
  Plug 'vim-scripts/align'
  Plug 'vitalk/vim-shebang'
  Plug 'wellle/targets.vim'
  Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
call plug#end()

" Backup, swap, and undo settings
set backupskip=*.log,/tmp/*
set backupext=.bak
set backupdir=$HOME/.local/share/nvim/backup//
set directory=$HOME/.local/share/nvim/swap//
set undodir=$HOME/.local/share/nvim/undo//
set viewdir=$HOME/.local/share/nvim/view//

" Other general settings
set tags^=.git/tags
set splitbelow
set splitright
set diffopt+=vertical
set clipboard^=unnamed,unnamedplus
set ignorecase
set smartcase
set wildmode=list:longest,list:full
set tabstop=2
set shiftwidth=2
set expandtab

" Persistent history across sessions
autocmd! vimrc CursorHold * if exists(':rshada') |
      \   rshada |
      \   wshada |
      \ endif

" File type-specific settings
augroup filetypes
  autocmd!
  autocmd FileType css,scss,slim,html,eruby,coffee,javascript,wxml setlocal iskeyword+=-
  autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  " Add other file-specific settings here
augroup end

" Plugin-specific settings
" Example: ALE
let g:ale_linters = {
  \ 'go': ['golint', 'go vet'],
  \ 'ruby': ['rubocop'],
  \ }

" Recommended mappings
nnoremap <C-p> :GFiles<CR>
" Add other useful mappings

" Recommended miscellaneous settings
set number
set numberwidth=3
set backspace=2
set autowrite
set nowrap
set hlsearch
nnoremap <CR> :nohlsearch<CR><CR>

" Your additional settings...

" Lastly, ensure the colorscheme is set
set background=dark
colorscheme nord

" Note: Your system-specific paths and configurations should be added appropriately.

