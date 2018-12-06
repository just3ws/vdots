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

let g:loaded_netrwPlugin = 1

let g:mapleader=';'
let g:maplocalleader=';'

call env#load()

let $DATA_DIR = file_utils#init_app_dir('')
let $BACKUP_DIR = file_utils#init_app_dir('/backup')
let $SWAP_DIR = file_utils#init_app_dir('/swap')
let $UNDO_DIR = file_utils#init_app_dir('/undo')
let $VIEW_DIR = file_utils#init_app_dir('/view')
let $SHADA_DIR = file_utils#init_app_dir('/shada')
let $FZF_HISTORY_DIR = file_utils#init_app_dir('/fzf/history')
let $STARTIFY_SESSION_DIR = file_utils#init_app_dir('/startify/session')
" let $GUTENTAGS_CACHE_DIR = file_utils#init_app_dir('/gutentags')
let $MRU_DIR = $DATA_DIR
let $NVIM_RUBY_LOG_FILE = $DATA_DIR . '/ruby.log'

set backupdir=$BACKUP_DIR//
set directory=$SWAP_DIR//
set undodir=$UNDO_DIR//
set viewdir=$VIEW_DIR//

call plugins#init()

set omnifunc=syntaxcomplete#Complete

set pastetoggle=<Leader>z " Toggle paste mode

set autoindent

set sessionoptions-=tabpages " Only save the current tab page in session.
set sessionoptions-=help " Don't save help windows in sessions.
set sessionoptions-=buffers " Don't save hidden and unloaded buffers in sessions.
set sessionoptions-=options " Don't persist options and mappings because it can corrupt sessions.

" Whitespace {{{
set expandtab
set shiftround
set shiftwidth=2
set smarttab
set softtabstop=2
set tabstop=2
" }}}

set autoread " Read when a file has been changed even outside of Vim.
set belloff=all
set clipboard& clipboard+=unnamed,unnamedplus
set complete-=i " Disable scanning included files
set complete-=t " Disable searching tags
set concealcursor=niv
set conceallevel=0
set display=lastline " Show as much as possible of a wrapped last line, not just '@'.
set fileformats=unix,dos,mac " Use Unix as the standard file type
set fillchars="diff:⣿,fold: ,vert:│"
set foldclose=all
set foldcolumn=2 " Side-column to show info on open and closed folds
set foldlevelstart=3
set hidden " Hide buffers when abandoned instead of unloading
set history=10000
set hlsearch
set ignorecase
set infercase " Completion with case-mismatch matches case-insensitive if possible
set iskeyword+=- " Remove - as a word boundary
set iskeyword+=$
set lazyredraw
set linebreak
set list
" set listchars=tab:␉\ \,trail:·,extends:…
set listchars=tab:\ \,trail:·,extends:…
set magic
set maxmempattern=2000000
set modeline " Automatically setting options from modelines
set modelines=1
set mouse=a
set noautochdir
set nocursorcolumn
set noerrorbells
set nojoinspaces " Only join lines with one space regardless of punctuation
set novisualbell
set nowrap
set path=.,** " Directories to search when using gf
set previewheight=15
set pumheight=25
set regexpengine=2 " Use the new NFA engine
set report=0 " Don't report on line changes
set scroll=8
set scrolljump=1
set scrolloff=10
set scrolloff=4
set secure
" set shell=/usr/local/bin/zsh
" set shell=/usr/local/bin/bash
set shell=/bin/bash
set shortmess+=c " default: shortmess=filnxtToO
set showcmd " Show incomplete cmds down the bottom
" set showfulltag
set showmatch
set showmode
set sidescroll=4
set sidescrolloff=4
set smartcase
set splitbelow
set splitright
set suffixes+=.log,.zwc,.sw?,.rbc,.doc,.docx,.exe,.gif,.jpg,.mp3,.mp4,.dll,.dvi,.pdf,.rtf,.tmp,.py?
set swapfile
set switchbuf=useopen
set synmaxcol=1000
set t_vb=
" set textwidth=0
set timeout
set timeoutlen=400
set ttimeout
set ttimeoutlen=10
set undofile
set undolevels=10000
set updatecount=100
set updatetime=2000 " Write swap files after 2 seconds of inactivity.
set virtualedit=block " Position cursor anywhere in visual block

" {{{ [WILDIGNORE]
set wildignore+=%*,*~,._*
set wildignore+=**/bower_modules/**,**/node_modules/**,*/.sass-cache/*
set wildignore+=**/tmp/**
set wildignore+=*.DS_Store,*.dmg
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpeg,*.jpg,*.png,*.psd,*.svg,*.webp
set wildignore+=*.aux,*.toc
set wildignore+=*.bz2,*.gz,*.kgb,*.rar,*.tar,*.xz,*.zip
set wildignore+=*.cbr,*.cbz,*.doc,*.docx,*.odf,*.pdf
set wildignore+=*.class,*.dll,*.exe,*.jar,*.o,*.obj,*.out,*.so
set wildignore+=*.divx,*.avi,*.mkv,*.mov,*.mp4,*.mpeg,*.mpg,*.m2ts,*.vob,*.webm
set wildignore+=*.egg-info,__pycache__
set wildignore+=*.eot,*.otf,*.ttf,*.woff,*.woff2
set wildignore+=*.log
set wildignore+=*.manifest
set wildignore+=*.mp3,*.oga,*.ogg,*.wav,*.flac
set wildignore+=*.pem
set wildignore+=*.pyc
set wildignore+=*.rbc,*/.bundle
set wildignore+=*.spl
set wildignore+=*.swn,*.swo,*.swp
set wildignore+=*.tags,tags
set wildignore+=*.ycm_extra_conf.py,*.ycm_extra_conf.pyc
set wildignore+=*.zwc
set wildignore+=*/.git,*/.git-metadata,*/.hg,*/.svn,.stversions
set wildignore+=*/.idea,*/.vscode
set wildignorecase
" }}}

set wildmode=longest,list:full " http://stackoverflow.com/a/526940/5228839
set wildoptions=tagfile
set wrapscan

set numberwidth=3
set number relativenumber
set cursorline

" Automatically close corresponding loclist when quitting a window
autocmd! vimrc QuitPre * if &filetype != 'qf' | silent! lclose | endif

let g:neosnippet#disable_runtime_snippets = { 'go': 1 }

let g:tagbar_autofocus = 1

command! Reload :source $MYVIMRC

command! Aliasrc  :edit $ZDOTDIR/.aliasrc
command! Saliasrc :split $ZDOTDIR/.aliasrc
command! Taliasrc :tabedit $ZDOTDIR/.aliasrc
command! Valiasrc :vsplit $ZDOTDIR/.aliasrc

command! Antigenrc  :edit $ZDOTDIR/.antigenrc
command! Santigenrc :split $ZDOTDIR/.antigenrc
command! Tantigenrc :tabedit $ZDOTDIR/.antigenrc
command! Vantigenrc :vsplit $ZDOTDIR/.antigenrc

command! Vimrc  :edit $MYVIMRC
command! Svimrc :split $MYVIMRC
command! Tvimrc :tabedit $MYVIMRC
command! Vvimrc :vsplit $MYVIMRC

command! Zpromptrc  :edit $ZDOTDIR/.zpromptrc
command! Szpromptrc :split $ZDOTDIR/.zpromptrc
command! Vzpromptrc :vsplit $ZDOTDIR/.zpromptrc
command! Tzpromptrc :tabedit $ZDOTDIR/.zpromptrc

command! Zshenv  :edit $ZDOTDIR/.zshenv
command! Szshenv :split $ZDOTDIR/.zshenv
command! Tzshenv :tabedit $ZDOTDIR/.zshenv
command! Vzshenv :vsplit $ZDOTDIR/.zshenv

command! Zshrc  :edit $ZDOTDIR/.zshrc
command! Szshrc :split $ZDOTDIR/.zshrc
command! Tzshrc :tabedit $ZDOTDIR/.zshrc
command! Vzshrc :vsplit $ZDOTDIR/.zshrc

" Saner command-line history
cnoremap <C-n> <down>
cnoremap <C-p> <up>

" Double tap to select whole line
nmap <Leader><Leader> V

" Avoid accidentally launching Ex mode
nnoremap Q <nop>

" Convert ; to : in modeline
" nnoremap ; :

" Clear highlight on enter
nnoremap <CR> :nohlsearch<CR><CR>

" Saner behavior of n and N
nnoremap <expr> N 'nN'[v:searchforward]
nnoremap <expr> n 'Nn'[v:searchforward]

nnoremap <C-p> :FZF<CR>
nnoremap <C-b> :Buffers<CR>
" nnoremap <C-c> :Colors<CR>
" nnoremap <C-f> :BLines<CR>
" nnoremap <C-g> :GitFiles<CR>
" nnoremap <C-m> :Mru<CR>
" nnoremap <C-h> :History<CR>
" nnoremap <C-t> :Files<CR>
" nnoremap <C-p> :Tags<CR>
" nnoremap ``` :Marks<CR>

" NERDTree
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>

" Saner movement through wrapped lines
nnoremap j gj
nnoremap k gk

" Swap the case for changing tabs
noremap <S-l> gt
noremap <S-h> gT

autocmd! vimrc VimResized * wincmd =

" Saner block shift
xnoremap < <gv
xnoremap > >gv

let g:airline_extensions = []

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1
let g:airline_left_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_sep=''
let g:airline_right_alt_sep=''

let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

let g:WebDevIconsOS = 'Darwin'

let g:ale_linters_explicit = 1
let g:ale_change_sign_column_color = 0
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_lint_delay = 1500
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_open_list = 0
let g:ale_pattern_options_enabled = 1
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = ''
let g:ale_linters = {}
let g:ale_fixers = {}
let g:ale_pattern_options = {
      \ '\.min\.js$': { 'ale_linters': [], 'ale_fixers': [] },
      \ '\.min\.css$': { 'ale_linters': [], 'ale_fixers': [] },
      \ }

let g:MRU_File = $MRU_DIR . '/mru_files'
let g:MRU_Max_Entries = 10000
let g:MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'

let g:fzf_history_dir = $FZF_HISTORY_DIR
let g:fzf_layout = { 'window': 'new' }
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

let g:ack_default_options = ' -s -H --nopager --nocolor --nogroup --column'
let g:ack_use_dispatch = 0
let g:ackhighlight = 1
let g:ackpreview = 0
let g:ack_mappings = {
      \ 't': '<C-w><CR><C-w>T',
      \ 'T': '<C-w><CR><C-w>TgT<C-w>j',
      \ 'o': '<CR>zz',
      \ 'O': '<CR><C-w><C-w>:ccl<CR>',
      \ 'go': '<CR><C-w>j',
      \ 'h': '<C-w><CR><C-w>K',
      \ 'H': '<C-w><CR><C-w>K<C-w>b',
      \ 'v': '<C-w><CR><C-w>H<C-w>b<C-w>J<C-w>t',
      \ 'gv': '<C-w><CR><C-w>H<C-w>b<C-w>J',
      \ }

" cnoreabbrev Ack LAck!
" nnoremap <Leader>a :LAck!<Space>

let g:gutentags_cache_dir = $GUTENTAGS_CACHE_DIR
let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
      \ '*.phar', '*.ini', '*.rst', '*.md',
      \ '*vendor/*/test*', '*vendor/*/Test*',
      \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
      \ '*var/cache*', '*var/log*'
      \ ]

let g:scratch_persistence_file = $DATA_DIR . '/scratch.vim'
let g:scratch_filetype = 'text'
let g:scratch_insert_autohide = 0
let g:scratch_autohide = 0

let g:indent_guides_auto_colors = 1
let g:indent_guides_default_mapping = 1
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_exclude_filetypes = ['help', 'markdown', 'nerdtree', 'startify', 'tagbar',]
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 3

let g:tagbar_autofocus = 1

let g:EditorConfig_exclude_patterns = [ 'fugitive://.*', 'scp://.*', ]

" Quote textobj helpers
xmap q iq
omap q iq

let g:vimwiki_list = [{ 'path': $VIMWIKI_HOME }]
let g:vimwiki_use_mouse=1

let g:deoplete#enable_at_startup = 1

call themes#nord()
