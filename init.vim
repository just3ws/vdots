" vim:fdm=marker

if has('gui_running')
  set guifont=Fira\ Mono:h14
  set guioptions+=c " Use console dialogs instead of popups if possible
  set guioptions-=L " Remove left-hand scroll bar
  set guioptions-=M " Do not source menu.vim
  set guioptions-=T " Remove toolbar
  set guioptions-=m " Remove menu bar
  set guioptions-=r " Remove right-hand scroll bar
endif

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

if !exists('g:syntax_on')
  syntax enable
endif

filetype on
filetype indent on
filetype plugin on

augroup vimrc
  autocmd!
augroup end

let g:mapleader=';'
let g:maplocalleader=';'

" {{{ [APP DIRS]
let $DATA_DIR = file_utils#init_app_dir('')
let $BACKUP_DIR = file_utils#init_app_dir('/backup')
let $SWAP_DIR = file_utils#init_app_dir('/swap')
let $UNDO_DIR = file_utils#init_app_dir('/undo')
let $VIEW_DIR = file_utils#init_app_dir('/view')
let $SHADA_DIR = file_utils#init_app_dir('/shada')
let $FZF_HISTORY_DIR = file_utils#init_app_dir('/fzf/history')
let $STARTIFY_SESSION_DIR = file_utils#init_app_dir('/startify/session')
" }}}

set backupdir=$BACKUP_DIR//
set directory=$SWAP_DIR//
set undodir=$UNDO_DIR//
set viewdir=$VIEW_DIR//

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" Plug 'hdima/python-syntax', { 'for': ['python'] }
Plug 'airblade/vim-gitgutter'
Plug 'chrisbra/vim-zsh'
Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
Plug 'dbmrq/vim-ditto'
Plug 'editorconfig/editorconfig-vim'
Plug 'google/yapf', { 'for': ['python'] } " eg.: <leader> = # Format Python code
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] }
Plug 'kana/vim-textobj-user'
Plug 'leshill/vim-json'
Plug 'majutsushi/tagbar'
Plug 'maksimr/vim-jsbeautify', { 'for': ['javascript', 'jsx', 'javascript.jsx'] }
Plug 'mhinz/vim-startify'
Plug 'mileszs/ack.vim'
Plug 'mtth/scratch.vim'
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'jsx', 'javascript.jsx'] }
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': ['ruby'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'jsx', 'javascript.jsx'] }
Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
Plug 'reedes/vim-textobj-quote'
Plug 'reedes/vim-textobj-sentence'
Plug 'reedes/vim-thematic'
Plug 'reedes/vim-wordy'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTree', 'NERDTreeToggle'] }
Plug 'sjl/vitality.vim'
Plug 'ternjs/tern_for_vim', { 'for': ['javascript'] }
Plug 'timothycrosley/isort', { 'for': ['python'] } " eg.: <leader>i # isort your Python imports
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler', { 'for': ['ruby'] }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails', { 'for': ['ruby'] }
Plug 'tpope/vim-rake', { 'for': ['ruby'] }
Plug 'tpope/vim-rbenv', { 'for': ['ruby'] }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby'] }
Plug 'vim-scripts/Align'
Plug 'vim-scripts/ruby-matchit', { 'for': ['ruby'] }
Plug 'w0rp/ale'
Plug 'wakatime/vim-wakatime'
Plug 'wellle/targets.vim'
Plug 'yegappan/mru'

" Initialize plugin system
call plug#end()

set omnifunc=syntaxcomplete#Complete

set pastetoggle=<leader>z " Toggle paste mode

set autoindent

set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

set sessionoptions-=tabpages " Only save the current tab page in session.
set sessionoptions-=help " Don't save help windows in sessions.
set sessionoptions-=buffers " Don't save hidden and unloaded buffers in sessions.
set sessionoptions-=options " Don't persist options and mappings because it can corrupt sessions.

set autoread " Read when a file has been changed even outside of Vim.
set belloff=all
set clipboard& clipboard+=unnamed,unnamedplus
set complete-=i " Disable scanning included files
set complete-=t " Disable searching tags
set concealcursor=niv
set conceallevel=2
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
set listchars=tab:␉\ \,trail:·,extends:…
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
set shell=/usr/local/bin/zsh
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
set textwidth=0
set timeout
set timeoutlen=400
set ttimeout
set ttimeoutlen=10
set undofile
set undolevels=10000
set updatecount=100
set updatetime=2000 " Write swap files after 2 seconds of inactivity.
set updatetime=500
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

set background=dark

set numberwidth=3
set number relativenumber
set cursorline

let g:ale_change_sign_column_color = 1
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

let g:ale_linters = {
      \ 'css': ['csslint', 'stylelint'],
      \ 'html': ['htmlhint', 'tidy'],
      \ 'liquid': ['htmlhint', 'tidy'],
      \ 'javascript': ['standard'],
      \ 'go': ['golint', 'go vet'],
      \ 'scss': ['stylelint'],
      \ 'markdown': ['mdl'],
      \ }

" \ 'markdown': ['mdl', 'alex'],

let g:ale_fixers = {
      \ 'css': ['prettier'],
      \ 'go': ['gofmt'],
      \ 'html': [
      \     'remove_trailing_lines',
      \     'trim_whitespace',
      \     'FixDeTabs'
      \ ],
      \ 'javascript': ['prettier'],
      \ 'json': ['prettier'],
      \ 'markdown': ['prettier'],
      \ 'python': ['autopep8', 'isort'],
      \ 'sass': ['prettier'],
      \ 'scss': ['prettier'],
      \ 'xml': ['prettier'],
      \ }

function! FixDeTabs(a,b) abort
  retab
endfunction

" \   { buffer, lines -> filter(lines, 'v:val' ) },
" \ 'yaml': ['yamllint'],
" ['remove_trailing_lines', 'trim_whitespace']
let g:ale_pattern_options = {
      \ '\.min\.js$': { 'ale_linters': [], 'ale_fixers': [] },
      \ '\.min\.css$': { 'ale_linters': [], 'ale_fixers': [] },
      \ }

" nmap <F8> <Plug>(ale_fix)

let g:ale_python_autopep8_options = '-aa'
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es6'
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_html_tidy_options = '-q -e -language en -utf8 --show-body-only 1'

" Automatically close corresponding loclist when quitting a window
autocmd! vimrc QuitPre * if &filetype != 'qf' | silent! lclose | endif

let g:scratch_persistence_file = $DATA_DIR . '/scratch.vim'
let g:scratch_filetype = 'text'
let g:scratch_insert_autohide = 0
let g:scratch_autohide = 0

set runtimepath+=/usr/local/opt/fzf

let g:fzf_history_dir = $FZF_HISTORY_DIR

let g:fzf_layout = { 'window': 'new' }
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

let g:indent_guides_auto_colors = 1
let g:indent_guides_default_mapping = 1
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_exclude_filetypes = [
      \ 'help',
      \ 'markdown',
      \ 'nerdtree',
      \ 'startify',
      \ 'tagbar',
      \ ]
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:tagbar_autofocus = 1
let g:tagbar_type_ruby = {
      \   'kinds': [
      \     'm:modules',
      \     'c:classes',
      \     'd:describes',
      \     'C:contexts',
      \     'f:methods',
      \     'F:singleton methods'
      \   ]
      \ }

if executable('ripper-tags')
  let g:tagbar_type_ruby = {
        \   'kinds': [
        \     'm:modules',
        \     'c:classes',
        \     'C:constants',
        \     'F:singleton methods',
        \     'f:methods',
        \     'a:aliases'
        \   ],
        \   'kind2scope': { 'c': 'class', 'm': 'class' },
        \   'scope2kind': { 'class': 'c' },
        \   'ctagsbin': 'ripper-tags',
        \   'ctagsargs': ['-f', '-']
        \ }
endif

let g:EditorConfig_exclude_patterns = [
      \ 'fugitive://.*',
      \ 'scp://.*',
      \ ]

let g:html_dynamic_folds = 1
let g:html_no_pre = 1
let g:html_use_css = 1
let g:html_use_encoding = 'UTF-8'
let g:html_no_rendering = 0 " Don't render italic, bold, links in HTML
let g:html_number_lines = 0 " TOhtml don't show line numbers

let g:elixir_use_markdown_for_docs = 1
let g:vim_markdown_folding_disabled = 1

command! -bar PackUpdate call plugins#reload() | call minpac#update()
command! -bar PackClean  call plugins#reload() | call minpac#clean()

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

command! Plugins :edit $XDG_CONFIG_HOME/vdots/autoload/plugins.vim
command! Splugins :split $XDG_CONFIG_HOME/vdots/autoload/plugins.vim
command! Tplugins :tabedit $XDG_CONFIG_HOME/vdots/autoload/plugins.vim
command! Vplugins :vsplit $XDG_CONFIG_HOME/vdots/autoload/plugins.vim

" if has('gui_running')
"   command! vimrc Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
"   command! vimrc Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
" endif

" autocmd! vimrc BufWritePre <buffer> :%s/\s\+$//e
" autocmd! vimrc InsertLeave,WinEnter * setlocal cursorline
" autocmd! vimrc InsertEnter,WinLeave * setlocal nocursorline
autocmd! vimrc VimResized * wincmd =

" Saner command-line history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Edit file in new tab
map <leader>ef :tabe <cfile><cr>

" Double tap to select whole line
nmap <leader><leader> V

" Dash.app
nmap <silent> <leader>d <plug>DashSearch

" ALE
" nmap <silent> <leader>ff <plug>(ale_fix)

nmap <silent> <leader>j <plug>(ale_next_wrap)
nmap <silent> <leader>k <plug>(ale_previous_wrap)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <plug>(EasyAlign)

" Saner line movements
" nnoremap $ g$
" nnoremap 0 g0

" Avoid accidentally launching Ex mode
nnoremap Q <nop>

" Convert ; to : in modeline
nnoremap ; : " B

" Clear highlight on enter
nnoremap <cr> :nohlsearch<cr><cr>

" Saner behavior of n and N
nnoremap <expr> N 'nN'[v:searchforward]
nnoremap <expr> n 'Nn'[v:searchforward]

" ALE
nnoremap <leader>ae :ALEDetail<cr>
nnoremap <leader>al :ALEToggle<cr>

autocmd! vimrc FileType css,scss,markdown,javascript,xml noremap <buffer> <leader>ff :ALEFix<cr>
autocmd! vimrc FileType html,liquid noremap <buffer> <leader>ff call HtmlBeautify()<cr>

" map <c-f> call JsBeautify()<cr>
" autocmd! vimrc FileType javascript noremap <buffer>  <c-f> call JsBeautify()<cr>
" autocmd! vimrc FileType json noremap <buffer> <c-f> call JsonBeautify()<cr>
" autocmd! vimrc FileType jsx noremap <buffer> <c-f> call JsxBeautify()<cr>
" autocmd! vimrc FileType html noremap <buffer> <c-f> call HtmlBeautify()<cr>
" autocmd! vimrc FileType css noremap <buffer> <c-f> call CSSBeautify()<cr>
" autocmd! vimrc FileType javascript vnoremap <buffer>  <c-f> call RangeJsBeautify()<cr>
" autocmd! vimrc FileType json vnoremap <buffer> <c-f> call RangeJsonBeautify()<cr>
" autocmd! vimrc FileType jsx vnoremap <buffer> <c-f> call RangeJsxBeautify()<cr>
" autocmd! vimrc FileType html,liquid vnoremap <buffer> <leader>ff call RangeHtmlBeautify()<cr>
" autocmd! vimrc FileType css vnoremap <buffer> <c-f> call RangeCSSBeautify()<cr>

" FZF
nnoremap <c-p> :FZF<cr>
nnoremap <leader>b :Buffers<cr>
" nnoremap <c-c> :Colors<cr>
" nnoremap <c-f> :BLines<cr>
" nnoremap <c-g> :GitFiles<cr>
" nnoremap <c-m> :Mru<cr>
" nnoremap <c-h> :History<cr>
" nnoremap <c-t> :Files<cr>
" nnoremap ``` :Marks<cr>

" Fugitive
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>

" Saner CTRL-L
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" NERDTree
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <leader>nf :NERDTreeFind<cr>

nnoremap <leader>tb :TagbarToggle<cr>

" Center highlighted search
nnoremap N Nzz
nnoremap n nzz

" Move current line
nnoremap [e :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e :<c-u>execute 'move +'. v:count1<cr>

nnoremap ^ g^

" Highlight last inserted text
nnoremap gV `[v`]

" Saner movement through wrapped lines
nnoremap j gj
nnoremap k gk

" Startify
nnoremap <leader>s :Startify<cr>

" ALE
noremap <leader>ad :ALEGoToDefinition<cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <plug>(EasyAlign)

" Saner block shift
xnoremap < <gv
xnoremap > >gv

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

call themes#nord()

" Align current paragraph with Leader + a
noremap <leader>a =ip

" Apply macro using Q
nnoremap Q @q
vnoremap Q :norm @q<cr>

" Swap the case for changing tabs
noremap <s-l> gt
noremap <s-h> gT

" Change panes without w
noremap <c-l> <c-w>l
noremap <c-h> <c-w>h
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k

" Quit file with Leader + q
noremap <leader>q :q<cr>

" Save file with Leader + s
nnoremap <leader>s :w<cr>
inoremap <leader>s <c-c>:w<cr>

" Clone paragrapha with cp
noremap cp yap<s-}>p

inoremap <tab> <c-r>=tab#complete()<cr>

highlight CursorLineNr ctermfg=0 guifg=white

" highlight! rubyClassVariable term=bold cterm=reverse ctermfg=1 gui=reverse guifg=#BF616A guibg=#2E3440
" highlight! rubyGlobalVariable term=bold cterm=reverse ctermfg=1 gui=reverse guifg=#BF616A guibg=#2E3440
highlight! rubyInterpolation term=bold cterm=reverse ctermfg=1 gui=reverse guifg=#BF616A guibg=#2E3440

map <c-f> :call JsBeautify()<cr>

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:jsx_ext_required = 0
let g:jedi#auto_initialization = 0
