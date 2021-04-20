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

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
set rtp+=/usr/local/opt/fzf

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  call dein#add('/usr/local/opt/fzf')
  call dein#add('prettier/vim-prettier', { 'build': '/usr/local/bin/brew reinstall prettier' })
  call dein#add('arcticicestudio/nord-vim')
  call dein#add('beloglazov/vim-textobj-quotes')
  call dein#add('christoomey/vim-run-interactive')
  call dein#add('dense-analysis/ale')
  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('fatih/vim-go', { 'build': '/usr/local/bin/brew reinstall go', 'hook_post_update': ':GoUpdateBinaries' })
  call dein#add('junegunn/fzf.vim', { 'build': '/usr/local/bin/brew reinstall fzf' })
  call dein#add('kana/vim-textobj-user')
  call dein#add('mhinz/vim-startify')
  call dein#add('mileszs/ack.vim')
  call dein#add('pbrisbin/vim-mkdir')
  call dein#add('preservim/nerdtree')
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('sjl/vitality.vim')
  call dein#add('tpope/vim-bundler')
  call dein#add('tpope/vim-commentary')
  call dein#add('tpope/vim-dispatch')
  call dein#add('tpope/vim-endwise')
  call dein#add('tpope/vim-eunuch')
  call dein#add('tpope/vim-projectionist')
  call dein#add('tpope/vim-ragtag')
  call dein#add('tpope/vim-rails')
  call dein#add('tpope/vim-rake')
  call dein#add('tpope/vim-rbenv')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-sensible')
  call dein#add('tpope/vim-surround')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('vim-scripts/align')
  call dein#add('vitalk/vim-shebang')
  call dein#add('wellle/targets.vim')

  call dein#add('nelstrom/vim-textobj-rubyblock')
  call dein#add('tek/vim-textobj-ruby')
  call dein#add('vim-ruby/vim-ruby')

  call dein#add('tpope/vim-git')
  call dein#add('tpope/vim-fugitive')
  " github integration
  call dein#add('tpope/vim-rhubarb')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

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

" set background=dark
call s:themes_best_colors()
let g:airline_theme = 'nord'
colorscheme nord
highlight Conceal guifg=#616E88 ctermfg=8

" Convert ; to : in modeline
nnoremap ; :

set backspace=2   " Backspace deletes like most programs in insert mode
set autowrite     " Automatically :write before running commands
set nowrap

set backupdir=$XDG_CONFIG_HOME/nvim/tmp,.
set directory=$XDG_CONFIG_HOME/nvim/tmp,.

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
  " autocmd BufRead,BufNewFile *.md setlocal spell
  " autocmd FileType gitcommit setlocal spell

  autocmd BufEnter * if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree' && winnr('$') > 1 | b# | exe "normal! \<c-w>\<c-w>" | :blast | endif

  " Automatically close corresponding loclist when quitting a window
  autocmd QuitPre * if &filetype != 'qf' | silent! lclose | endif
augroup END

" ALE linting events
augroup ale
  autocmd!

  autocmd VimEnter *
        \ set updatetime=1000 |
        \ let g:ale_lint_on_text_changed = 0

  autocmd CursorHold * call ale#Queue(0)
  autocmd CursorHoldI * call ale#Queue(0)
  autocmd InsertEnter * call ale#Queue(0)
  autocmd InsertLeave * call ale#Queue(0)
augroup END

let g:EditorConfig_exclude_patterns = [ 'fugitive://.*', 'scp://.*', ]

set number
set numberwidth=3

" Quote textobj helpers
xmap q iq
omap q iq

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

let g:ale_enabled = 0

let g:ale_shell = '/usr/local/bin/zsh'

let g:ale_change_sign_column_color = 0
let g:ale_completion_enabled = 1

let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WRN'
let g:ale_fix_on_save = 0
let g:ale_lint_delay = 500
let g:ale_lint_on_enter = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_set_balloons = 1
let g:ale_set_highlights = 1
let g:ale_sign_error = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
let g:ale_sign_warning = ''

let g:airline#extensions#ale#enabled = 1

let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'ruby': ['remove_trailing_lines', 'trim_whitespace', 'rubocop'],
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

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif


" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  else
    return "\<C-p>"
  endif
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

" " vim-test mappings
" nnoremap <silent> <Leader>t :TestFile<CR>
" nnoremap <silent> <Leader>s :TestNearest<CR>
" nnoremap <silent> <Leader>l :TestLast<CR>
" nnoremap <silent> <Leader>a :TestSuite<CR>
" nnoremap <silent> <Leader>gt :TestVisit<CR>

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

let g:ack_default_options = ' -s -H --nopager --nocolor --nogroup --column'
let g:ack_use_dispatch = 0
let g:ackhighlight = 1
let g:ackpreview = 0
let g:ack_mappings = {
      \   't': '<C-w><CR><C-w>T',
      \   'T': '<C-w><CR><C-w>TgT<C-w>j',
      \   'o': '<CR>zz',
      \   'O': '<CR><C-w><C-w>:ccl<CR>',
      \   'go': '<CR><C-w>j',
      \   'h': '<C-w><CR><C-w>K',
      \   'H': '<C-w><CR><C-w>K<C-w>b',
      \   'v': '<C-w><CR><C-w>H<C-w>b<C-w>J<C-w>t',
      \   'gv': '<C-w><CR><C-w>H<C-w>b<C-w>J',
      \ }

" nnoremap <leader>ct :silent ! ctags -R --languages=ruby --exclude=.git --exclude=log -f .git/tags<cr>
" nnoremap <leader>ct :silent ! ripper-tags --tag-relative=always --recurse=yes --exclude=vendor --exclude=.git --exclude=log --tag-file .git/tags<cr><cr>

" Saner movement through wrapped lines
nnoremap j gj
nnoremap k gk

" Swap the case for changing tabs
noremap <S-l> gt
noremap <S-h> gT

nnoremap <C-p> :FZF<CR>
nnoremap <C-b> :Buffers<CR>

let g:airline_extensions = []
