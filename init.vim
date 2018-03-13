augroup Vimrc
  autocmd!
augroup END

" {{{ [NEOVIM]

if has('nvim')
  let g:python2_host_prog = expand('~/.pyenv/versions/neovim2/bin/python')
  let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')
endif

" }}}

" {{{ [GUI]

if has('gui_running')
  set guifont=Sauce\ Code\ Pro\ Nerd\ Font\ Complete:h16
endif

" }}}

" {{{ [ENCODING]

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

" }}}

" {{{ [XDG]

let $XDG_CACHE_HOME = expand($HOME . '/.cache')
let $XDG_CONFIG_HOME = expand($HOME . '/.config')
let $XDG_DATA_HOME = expand($HOME . '/.local/share')

if has('nvim')
  let $VIM_HOME = expand($XDG_DATA_HOME . '/nvim')
  let $VIM_CACHE = expand($XDG_CACHE_HOME . '/nvim')
else
  let $VIM_HOME = expand($XDG_DATA_HOME . '/vim')
  let $VIM_CACHE = expand($XDG_CACHE_HOME . '/vim')
endif

if !isdirectory($VIM_HOME)
  call mkdir($VIM_HOME, 'p')
endif

if !isdirectory($VIM_CACHE)
  call mkdir(expand($VIM_CACHE), 'p')
endif

" }}}

if has('nvim')
  " {{{ [SHADA]
  let $SHADA_DIR = $VIM_HOME . '/shada'
  if !isdirectory($SHADA_DIR)
    call mkdir($SHADA_DIR, 'p')
  endif

  " ' - Maximum number of previously edited files marks
  " < - Maximum number of lines saved for each register
  " @ - Maximum number of items in the input-line history to be
  " s - Maximum size of an item contents in KiB
  " h - Disable the effect of 'hlsearch' when loading the shada
  set shada='300,<10,@50,s100,h

  " Write history on idle, for sharing among different sessions
  autocmd! Vimrc CursorHold * if exists(':rshada') | rshada | wshada | endif
  " }}}
else
  " {{{ [VIMINFO]
  set viminfo='100,n$VIM_HOME/viminfo
  " }}}
endif

" {{{ [BACKUP DIR]

let $BACKUP_DIR = $VIM_HOME . '/backup'
if !isdirectory($BACKUP_DIR)
  call mkdir($BACKUP_DIR, 'p')
endif

set backupdir=$BACKUP_DIR//

" }}}

" {{{ [DOC DIR]

let $DOC_DIR = $VIM_HOME . '/doc'
if !isdirectory($DOC_DIR)
  call mkdir($DOC_DIR, 'p')
endif

" }}}

" {{{ [SWAP DIR]

let $SWAP_DIR = $VIM_HOME . '/swap'
if !isdirectory($SWAP_DIR)
  call mkdir($SWAP_DIR, 'p')
endif

set directory=$SWAP_DIR//

" }}}

" {{{ [UNDO DIR]

let $UNDO_DIR = $VIM_HOME . '/undo'
if !isdirectory($UNDO_DIR)
  call mkdir($UNDO_DIR, 'p')
endif

set undodir=$UNDO_DIR//

" }}}

" {{{ [VIEW DIR]

let $VIEW_DIR = $VIM_HOME . '/view'
if !isdirectory($VIEW_DIR)
  call mkdir($VIEW_DIR, 'p')
endif

set viewdir=$VIEW_DIR//

" }}}

" {{{ [LEADER]

let g:mapleader=';'
let g:maplocalleader=';'

" }}}

" {{{ [SETTINGS]

if !exists('g:syntax_on')
  syntax enable
endif

filetype on
filetype indent on
filetype plugin on

if has('nvim')
  set inccommand= " Incremental everything
endif

" set cinoptions+=:0,g0,N-1,m1
" set complete=. " default: .,w,b,u,t
" set completeopt=menu,longest,noinsert,noselect
" set foldenable
" set foldlevel=100 " Don't autofold anything (but I can still fold manually)
" set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds
" set formatoptions+=o " Insert comment leader after hitting o or O in normal mode

set autoindent " Overwritten by cindent or filetype rules
set autoread " Read when a file has been changed even outside of Vim.
set backup
set backupskip+=*.log " Don't backup log files
set belloff=all
set cindent " Default to C style indentation
set clipboard& clipboard+=unnamed,unnamedplus
set complete-=i " disable scanning included files
set complete-=t " disable searching tags
set concealcursor=niv
set conceallevel=2
set display=lastline " Show as much as possible of a wrapped last line, not just '@'.
set expandtab
set fileformats=unix,dos,mac " Use Unix as the standard file type
set fillchars="diff:⣿,fold: ,vert:│"
set foldclose=all
set foldcolumn=1
set foldmethod=marker " Fold on the marker
set formatoptions+=1 " Don't break lines after a one-letter word
set formatoptions+=c " Autowrap comments using textwidth
set formatoptions+=j " Delete comment character when joining commented lines
set formatoptions+=j " Remove comment leader when joining lines
set formatoptions+=l " do not wrap lines that have been longer when starting insert mode already
set formatoptions+=n " Recognize numbered lists
set formatoptions+=q " Allow formatting of comments with 'gq'.
set formatoptions+=r " Insert comment leader after hitting <Enter>
set formatoptions+=t " Auto-wrap text using textwidth
set formatoptions-=t " Don't auto-wrap text
set hidden " Hide buffers when abandoned instead of unloading
set history=10000
set hlsearch
set ignorecase
set infercase " Completion with case-mismatch matches case-insensitive if possible
set iskeyword+=?,!,@
set lazyredraw
set linebreak
set list
set listchars=tab:␉\ \,trail:·,extends:… ",eol:¬ Set trails for tabs and spaces
set magic
set maxmempattern=2000000
set modeline " Automatically setting options from modelines
set modelines=1
set mouse=a
set noautochdir
set nocursorcolumn
set nocursorline " Don’t use cursorline, as it causes constant redrawing, which, when combined with syntax highlighting, drops performance
set noerrorbells
set nojoinspaces " Only join lines with one space regardless of punctuation
set norelativenumber
set nostartofline
set novisualbell
set nowrap
set number
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
set sessionoptions+=tabpages
set sessionoptions-=blank
set sessionoptions-=buffers
set sessionoptions-=folds
set sessionoptions-=globals
set sessionoptions-=help
set sessionoptions-=options
set shell=/usr/local/bin/zsh
set shiftround
set shiftwidth=2
set shortmess+=c " default: shortmess=filnxtToO
set showcmd " Show incomplete cmds down the bottom
set showfulltag
set showmatch
set showmode
set sidescroll=4
set sidescrolloff=4
set smartcase
set smartindent " Use shiftwidth not tabstop
set smarttab
set softtabstop=2
set splitbelow
set splitright
set suffixes+=.log,.zwc,.sw?,.rbc,.doc,.docx,.exe,.gif,.jpg,.mp3,.mp4,.dll,.dvi,.pdf,.rtf,.tmp,.py?
set swapfile
set switchbuf=useopen
set synmaxcol=1000 " Don't syntax highlight long lines
set t_vb=
set tabstop=2
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
set viewoptions+=slash,unix
set viewoptions-=options
set virtualedit=block " Position cursor anywhere in visual block
set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png " Image
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
set wildignore+=*.manifest " gb
set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.out,*.class " Compiler
set wildignore+=*.swp,*.swo,*.swn " Vim
set wildignore+=*.ycm_extra_conf.py,*.ycm_extra_conf.pyc " YCM
set wildignore+=*.zwc " Zsh
set wildignore+=*/.git,*/.hg,*/.svn " vcs
set wildignore+=.bundle,*/.git-metadata
set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
set wildignore+=__pycache__,*.egg-info
set wildignore+=tags,*.tags " Tags
set wildignorecase
set wildmode=list:longest,full
set wildmode=longest,list:full " http://stackoverflow.com/a/526940/5228839
set wildoptions=tagfile
set wrapscan
set writebackup " Make a backup of the original file when writing

" }}}

" {{{ [FILETYPES]

" {{{ [Ruby, Rake, and RSpec]

autocmd! Vimrc BufRead,BufNewFile *.[cC]apfile,[cC]apfile,*.cap setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.builder,*.rxml,*.rjs,*.jbuilder,*.prawn setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.cr setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.gemspec setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.rb,*.rbw setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.ru setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile Berksfile,Berksfile.lock setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile COMMIT_EDITMSG setfiletype gitcommit
autocmd! Vimrc BufRead,BufNewFile Gemfile setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile Guardfile setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile Puppetfile setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile Thorfile,Vagrantfile setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile [rR]antfile,*.rant setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile {.,}irbrc setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile {.,}pryrc setfiletype ruby

autocmd! Vimrc BufRead,BufNewFile *.erb,*.rhtml setfiletype eruby

autocmd! Vimrc BufRead,BufNewFile [rR]akefile,*.rake setfiletype rake

autocmd! Vimrc BufRead,BufNewFile *_spec.rb set syntax=rspec

" }}}
"
" {{{ [Haml]

autocmd! Vimrc BufRead,BufNewFile *.haml setfiletype haml

" }}}

" {{{ [Git]

autocmd! Vimrc BufRead,BufNewFile MERGE_MSG setfiletype gitcommit
autocmd! Vimrc BufRead,BufNewFile *.gitconfig setfiletype gitconfig

" }}}

" {{{ [AppleScript]

autocmd! Vimrc BufRead,BufNewFile *.scpt,*.scptd,*.applescript, setfiletype applescript

" }}}

" {{{ [HOSTS]

autocmd! Vimrc BufRead,BufNewFile */etc/host.conf setfiletype hostconf
autocmd! Vimrc BufRead,BufNewFile /private/etc/hosts,/etc/hosts setfiletype hostaccess

" }}}

" {{{ [tmux]

autocmd! Vimrc BufRead,BufNewFile {.,}tmux*.conf* setfiletype tmux

" }}}

" {{{ [Markdown]

autocmd! Vimrc BufRead,BufNewFile *.{md,mkd,markdown*} setfiletype markdown
autocmd! Vimrc BufRead,BufNewFile TODO,README setfiletype markdown

" }}}

" {{{ [Nginx]

autocmd! Vimrc BufRead,BufNewFile nginx.conf,nginx*.conf setfiletype nginx
autocmd! Vimrc BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

" }}}

" {{{ [Delimited Files]

autocmd! Vimrc BufRead,BufNewFile *.csv,*.tsv setfiletype csv

" }}}

" {{{ [CoffeeScript]

autocmd! Vimrc BufRead,BufNewFile *.coffee setfiletype coffee

" }}}

" {{{ [Postgres]

autocmd! Vimrc BufRead,BufNewFile *.psql,*.pgsql,*.plpgsql setfiletype pgsql
autocmd! Vimrc BufRead,BufNewFile *.sql setfiletype pgsql
autocmd! Vimrc BufRead,BufNewFile .psqlrc setfiletype pgsql

" }}}

" {{{ [Zsh]

autocmd! Vimrc BufRead,BufNewFile *zsh/functions* setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile *zsh/*rc setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile .zprofile setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile .antigenrc setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile *.zsh setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile *.zsh setfiletype zsh

" }}}

" }}}

" {{{ [MINPAC]

packadd minpac
call minpac#init()

" }}}

" {{{ [BUILTINS]

let g:loaded_2html_plugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" }}}

" {{{ [GENERAL PLUGINS]

call minpac#add('tpope/vim-abolish')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-dispatch')
call minpac#add('tpope/vim-eunuch')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-sensible')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')

" }}}

" {{{ [FANCY GLYPHS]

call minpac#add('ryanoasis/vim-devicons')

let g:webdevicons_enable = 1

let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

let g:webdevicons_conceal_nerdtree_brackets = 1
let g:webdevicons_enable_ctrlp = 0
let g:webdevicons_enable_denite = 0
let g:webdevicons_enable_flagship_statusline = 0
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_unite = 0
let g:webdevicons_enable_vimfiler = 0

" }}}

" {{{ [STATUS LINE]

call minpac#add('skywind3000/asyncrun.vim')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')

let g:airline_extensions = []

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#obsession#enabled = 0
let g:airline#extensions#quickfix#enabled = 1
let g:airline#extensions#unicode#enabled = 1
let g:airline#extensions#term#enabled = 1
let g:airline#extensions#wordcount#enabled = 0

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1

if exists('g:loaded_webdevicons')
  let g:webdevicons_enable_airline_statusline = 1
  let g:webdevicons_enable_airline_tabline = 1
endif

" {{{ [TMUX]

call minpac#add('edkolev/tmuxline.vim')

" }}}

" }}}

" {{{ [ALIGNMENT]

call minpac#add('junegunn/vim-easy-align')
call minpac#add('vim-scripts/Align')

" }}}

" {{{ [STARTIFY]

call minpac#add('mhinz/vim-startify')

autocmd! Vimrc FileType startify setlocal nofoldenable
autocmd! Vimrc FileType startify setlocal nolist
autocmd! Vimrc FileType startify setlocal nohlsearch

let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_custom_header = []
let g:startify_disable_at_vimenter = 0
let g:startify_enable_unsafe = 1
let g:startify_files_number = 5
let g:startify_fortune_use_unicode = 1
let g:startify_recursive_dir = 1
let g:startify_relative_path = 1
let g:startify_session_autoload = 0
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence = 1
let g:startify_session_sort = 1
let g:startify_show_files = 1
let g:startify_show_files_number = 3
let g:startify_update_oldfiles = 1
let g:startify_use_env = 1
let g:startify_show_sessions = 1

let g:startify_list_order = [
      \ [     'files'], 'files'     ,
      \ [       'dir'], 'dir'       ,
      \ [  'sessions'], 'sessions'  ,
      \ [ 'bookmarks'], 'bookmarks' ,
      \ [  'commands'], 'commands'
      \ ]

let g:startify_skiplist = [
      \ $HOME.'/private/*',
      \ $VIMRUNTIME.'/doc',
      \ '/Desktop/',
      \ '/doots/',
      \ '/dooty/',
      \ '/repos/',
      \ '/tmp/',
      \ 'COMMIT_EDITMSG',
      \ '\.\(jpg\|png\|jpeg\|txt\)',
      \ '\.git',
      \ '\.gvimrc$',
      \ '\.log$',
      \ '\.vimrc$',
      \ '\init.vim$',
      \ 'bundle/.*/doc',
      \ 'vimpager',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\').'doc'
      \ ]

let g:startify_bookmarks = [
      \  { 'z': '~/.config/zsh/.zshrc' },
      \  { 'Z': '~/.zshenv' },
      \  { 't': '~/.tmux.conf' }
      \ ]

" if has('nvim')

"   let g:startify_bookmarks += { 'v': '~/.config/nvim/init.vim' }

" else

"   let g:startify_bookmarks += { 'v': '~/.vimrc' }

" endif

let g:startify_commands = [
      \ {'p': ':PackUpdate'},
      \ {'P': ':PackClean'},
      \ ]

" if has('nvim')

"   let g:startify_commands += {'h': ':CheckHealth'}

"   let g:startify_commands += {'T': ':terminal'}

" endif

function! ToStartify()
  if winnr('$') == 1 && buffer_name(winbufnr(winnr())) !=? ''
    vsplit
    Startify
    exec "normal \<c-w>w"
  endif
endfunction

autocmd! Vimrc QuitPre * call ToStartify()

" }}}

" {{{ [ALE]

call minpac#add('w0rp/ale')

let g:ale_change_sign_column_color = 1
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_lint_delay = 1500
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 0
let g:ale_pattern_options_enabled = 1
let g:ale_sign_column_always = 0

let g:ale_linters = {
      \ 'css': ['csslint', 'stylelint'],
      \ 'scss': ['stylelint'],
      \ 'html': ['htmlhint', 'tidy'],
      \ 'javascript': ['standard'],
      \ 'ruby': ['rubocop', 'ruby'],
      \ 'vim': ['vint'],
      \ }

let g:ale_fixers = {
      \ 'css': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \ 'go': ['remove_trailing_lines', 'trim_whitespace', 'gofmt', 'golint', 'go vet'],
      \ 'html': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['remove_trailing_lines', 'trim_whitespace', 'prettier', 'eslint'],
      \ 'json': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \ 'markdown': ['remove_trailing_lines', 'trim_whitespace', 'prettier', 'alex'],
      \ 'python': ['remove_trailing_lines', 'trim_whitespace', 'autopep8', 'isort'],
      \ 'ruby': ['remove_trailing_lines', 'trim_whitespace', 'rubocop'],
      \ 'sass': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \ 'scss': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
      \ 'vim': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'xml': ['remove_trailing_lines', 'trim_whitespace', 'prettier']
      \ }

let g:ale_pattern_options = {
      \ '\.min\.js$': { 'ale_linters': [], 'ale_fixers': [] },
      \ '\.min\.css$': { 'ale_linters': [], 'ale_fixers': [] },
      \ }

let g:ale_python_autopep8_options = '-aa'

highlight clear ALEErrorSign
highlight clear ALEWarningSign

" Automatically close corresponding loclist when quitting a window

autocmd! Vimrc QuitPre * if &filetype != 'qf' | silent! lclose | endif

" }}}

" {{{ [SCRATCH BUFFER]

call minpac#add('mtth/scratch.vim')

let g:scratch_persistence_file = $VIM_CACHE . '/scratch.vim'
let g:scratch_filetype = 'text'
let g:scratch_insert_autohide = 0
let g:scratch_autohide = 0

" }}}

" {{{ [TEXTOBJS]

call minpac#add('kana/vim-textobj-user')

call minpac#add('reedes/vim-textobj-sentence')

" augroup textobj_sentence

"   autocmd!

"   autocmd FileType markdown call textobj#sentence#init()

"   autocmd FileType textile call textobj#sentence#init()

" augroup END

call minpac#add('reedes/vim-textobj-quote')

" augroup textobj_quote

"   autocmd!

"   autocmd FileType markdown call textobj#quote#init()

"   autocmd FileType textile call textobj#quote#init()

"   autocmd FileType text call textobj#quote#init({'educate': 0})

" augroup END

" }}}

" {{{ [SYNTAX]

call minpac#add('sheerun/vim-polyglot')

" }}}

" {{{ [GIT]

call minpac#add('tpope/vim-git')
call minpac#add('tpope/vim-fugitive')

" }}}

" {{{ <HTML>

call minpac#add('tpope/vim-ragtag')

let g:html_dynamic_folds = 1
let g:html_no_pre = 1
let g:html_use_css = 1
let g:html_use_encoding = 'UTF-8'
let g:html_no_rendering = 0 " Don't render italic, bold, links in HTML
let g:html_number_lines = 0 " TOhtml don't show line numbers

" }}}

" {{{ |RUBY|

call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-rake')
call minpac#add('tpope/vim-rbenv')
call minpac#add('vim-ruby/vim-ruby')
call minpac#add('tpope/vim-endwise')
call minpac#add('nelstrom/vim-textobj-rubyblock')
call minpac#add('vim-scripts/ruby-matchit')

autocmd! FileType ruby set omnifunc=rubycomplete#Complete

let g:ruby_fold = 1
let g:ruby_foldable_groups = 'if def do begin case for {  [ % string # << __END__'
let g:ruby_minlines = 1000
let g:ruby_operators = 1
let g:ruby_space_errors = 1
let g:ruby_spellcheck_strings = 0
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_include_object = 1
let g:rubycomplete_include_objectspace = 1
let g:rubycomplete_load_gemfile = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_rails_proactive = 1
let g:rubycomplete_use_bundler = 1

let g:rails_projections = {
  \   'app/admin/*.rb': { 'command': 'admin' },
  \   'app/decorators/*_decorator.rb': { 'command': 'decorator' },
  \   'app/inputs/*_input.rb': { 'command': 'input' },
  \   'app/services/*_service.rb': { 'command': 'service' },
  \   'app/uploaders/*_uploader.rb': {
  \     'command': 'uploader',
  \     'template': 'class %SUploader < CarrierWave::Uploader::Base\nend',
  \     'test': [
  \       'test/unit/%s_uploader_test.rb',
  \       'spec/models/%s_uploader_spec.rb'
  \     ],
  \     'keywords': 'process version'
  \   },
  \   'app/workers/*_worker.rb': { 'command': 'worker' },
  \   'features/support/*.rb': { 'command': 'support' },
  \   'features/support/env.rb': { 'command': 'support' },
  \   'spec/factories/*.rb': { 'command': 'factory' }
  \ }

" }}}

" {{{ [PYTHON]

call minpac#add('Vimjas/vim-python-pep8-indent')

" }}}

" " {{{ (CLOJURE)

" call minpac#add('tpope/vim-leiningen')

" call minpac#add('tpope/vim-fireplace')

" call minpac#add('tpope/vim-classpath')

" call minpac#add('tpope/vim-salve')

" call minpac#add('guns/vim-sexp')

" call minpac#add('tpope/vim-sexp-mappings-for-regular-people')

" " }}}

" {{{ [JSON]

call minpac#add('tpope/vim-jdaddy')

" }}}

" {{{ [MARKDOWN]

call minpac#add('plasticboy/vim-markdown')

let g:vim_markdown_folding_disabled = 1

" }}}

" {{{ [JEKYLL]

call minpac#add('tpope/vim-liquid')
call minpac#add('parkr/vim-jekyll')

" }}}

" {{{ [THEMES/NORD]

if has('termguicolors')
  set termguicolors
else
  set t_Co=256
endif

" call minpac#add('chrishunt/color-schemes')

" call minpac#add('chriskempson/vim-tomorrow-theme')

" call minpac#add('flazz/vim-colorschemes')

" call minpac#add('rafi/awesome-vim-colorschemes')

" call minpac#add('rickharris/vim-blackboard')

" call minpac#add('rickharris/vim-monokai')

" call minpac#add('rickharris/vim-railscasts')

call minpac#add('arcticicestudio/nord-vim', { 'branch': 'develop' })

set background=dark

let g:nord_comment_brightness = 20
let g:nord_italic = 0
let g:nord_italic_comments = 0
let g:nord_uniform_diff_background = 0
let g:nord_uniform_status_lines = 0

if exists('g:loaded_airline_themes')
  let g:airline_theme = 'nord'
endif

augroup nord_overrides
  autocmd!

  autocmd ColorScheme nord highlight Folded ctermbg=0 ctermbg=12 guibg=#3B4252 guifg=#81A1C1 gui=bold cterm=italic,bold
  autocmd ColorScheme nord highlight FoldColumn ctermbg=0 guifg=#B48EAD cterm=bold gui=bold
  autocmd ColorScheme nord highlight Comment ctermfg=12 guifg=#81A1C1
  autocmd ColorScheme nord highlight Search ctermbg=3 ctermfg=0 guibg=#EBCB8B guifg=#3B4252
  autocmd ColorScheme nord highlight IncSearch ctermbg=8 guibg=#4C566A
augroup END

colorscheme nord

" }}}

" {{{ [NAVIGATION]

call minpac#add('yegappan/mru')

" {{{ [NAVIGATION/FZF]

set runtimepath+=/usr/local/opt/fzf

let $FZF_HISTORY_DIR = $VIM_CACHE . '/fzf/history'
if !isdirectory($FZF_HISTORY_DIR)
  call mkdir($FZF_HISTORY_DIR, 'p')
endif

let g:fzf_history_dir = $FZF_HISTORY_DIR

call minpac#add('junegunn/fzf.vim')
call minpac#add('fszymanski/fzf-gitignore')

" }}}

" {{{ [NAVIGATION/VIMGREPPER]

call minpac#add('mhinz/vim-grepper')

" }}}

" {{{ [NAVIGATION/ACK]

call minpac#add('mileszs/ack.vim')

" }}}

" }}}

" {{{ [NETRW]

" call minpac#add('tpope/vim-vinegar')

" let g:netrw_altv = 1 " open files to right

" let g:netrw_banner = 0 " no banner

" let g:netrw_browse_split = 4

" let g:netrw_list_hide = &wildignore

" let g:netrw_liststyle = 3 " tree format

" let g:netrw_preview = 1 " open previews vertically

" let g:netrw_sort_sequence = '[\/]$,*'

" let g:netrw_winsize = 25

" autocmd! Vimrc FileType netrw nnoremap q :bd<cr>

" }}}

" {{{ [NERDTREE]

call minpac#add('scrooloose/nerdtree')
call minpac#add('Xuyuanp/nerdtree-git-plugin')

autocmd! Vimrc FileType nerdtree setlocal nofoldenable
autocmd! Vimrc FileType nerdtree setlocal nolist
autocmd! Vimrc FileType nerdtree setlocal nohlsearch

let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrows = 1
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeHighlightFolders = 1
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeIgnore = ['\~$', '\v\.(git|vscode|pyc|ico|png|jpeg|gif|svg|ttf|woff|woff2|eot|mp4|exe|dmg|jpg|pdf|pem|DS_Store)$']
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMapRefreshRoot = 'R'
let g:NERDTreeMapToggleHidden = 'h'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMouseMode = 3 " Click to open all node types
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeShowBookmarks = 0
let g:NERDTreeShowHidden = 1
let g:NERDTreeSortHiddenFirst = 1

" }}}

" {{{ [SNIPPETS]

" call minpac#add('MarcWeber/vim-addon-mw-utils')

" call minpac#add('tomtom/tlib_vim')

" call minpac#add('garbas/vim-snipmate')

call minpac#add('honza/vim-snippets')

" call minpac#add('sirver/ultisnips')

" let g:UltiSnipsExpandTrigger = '<tab>'

" let g:UltiSnipsListSnippets = '<tab>'

" let g:UltiSnipsJumpForwardTrigger = '<tab>'

" let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" let g:UltiSnipsEditSplit = 'vertical'

" let g:snipMate.scope_aliases = {}

" let g:snipMate.scope_aliases['ruby'] = 'ruby,rails,rspec'

" let g:snipMate.scope_aliases['eruby'] = 'eruby,html'

" let g:snipMate.scope_aliases['scss'] = 'scss,css'

" let g:snipMate.scope_aliases['javascript'] = 'javascript'

" let g:snipMate.scope_aliases['javascript.jsx'] = 'javascript,jsx'

" }}}

" {{{ [DASH]

call minpac#add('rizzatti/dash.vim')

" }}}

" {{{ [INDENT GUIDES]

call minpac#add('nathanaelkane/vim-indent-guides')

let g:indent_guides_auto_colors = 1
let g:indent_guides_default_mapping = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'startify', 'markdown', 'tagbar']
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd  ctermbg=238

" autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=249

" }}}

" {{{ [TAGS]

call minpac#add('majutsushi/tagbar')

let g:tagbar_autofocus = 1

let g:tagbar_type_ruby = {
      \ 'kinds' : [
      \ 'm:modules',
      \ 'c:classes',
      \ 'd:describes',
      \ 'C:contexts',
      \ 'f:methods',
      \ 'F:singleton methods'
      \ ]
      \ }

if executable('ripper-tags')
  let g:tagbar_type_ruby = {
        \ 'kinds'      : ['m:modules',
        \ 'c:classes',
        \ 'C:constants',
        \ 'F:singleton methods',
        \ 'f:methods',
        \ 'a:aliases'],
        \ 'kind2scope' : { 'c' : 'class',
        \ 'm' : 'class' },
        \ 'scope2kind' : { 'class' : 'c' },
        \ 'ctagsbin'   : 'ripper-tags',
        \ 'ctagsargs'  : ['-f', '-']
        \ }
endif

" }}}

" {{{ [COMMANDS]

command! Reload     :execute ':write ' . $MYVIMRC.' | :source ' . $MYVIMRC
command! PackUpdate :packadd minpac | :source $MYVIMRC | :call minpac#update()
command! PackClean  :packadd minpac | :source $MYVIMRC | :call minpac#clean()

command! Aliasrc   :edit $XDG_CONFIG_HOME/zsh/.aliasrc
command! Antigenrc :edit $XDG_CONFIG_HOME/zsh/.antigenrc
command! Vimrc     :edit $MYVIMRC
command! Zpromptrc :edit $XDG_CONFIG_HOME/zsh/.zpromptrc
command! Zshenv    :edit $HOME/.zshenv
command! Zshrc     :edit $XDG_CONFIG_HOME/zsh/.zshrc

command! Valiasrc   :vsplit $XDG_CONFIG_HOME/zsh/.aliasrc
command! Vantigenrc :vsplit $XDG_CONFIG_HOME/zsh/.antigenrc
command! Vvimrc     :vsplit $MYVIMRC
command! Vzpromptrc :vsplit $XDG_CONFIG_HOME/zsh/.zpromptrc
command! Vzshenv    :vsplit $HOME/.zshenv
command! Vzshrc     :vsplit $XDG_CONFIG_HOME/zsh/.zshrc

command! Saliasrc   :split $XDG_CONFIG_HOME/zsh/.aliasrc
command! Santigenrc :split $XDG_CONFIG_HOME/zsh/.antigenrc
command! Svimrc     :split $MYVIMRC
command! Szpromptrc :split $XDG_CONFIG_HOME/zsh/.zpromptrc
command! Szshenv    :split $HOME/.zshenv
command! Szshrc     :split $XDG_CONFIG_HOME/zsh/.zshrc

if has('gui_running')
  command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
  command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
endif

" }}}

" {{{ [AUTOCMDS]

autocmd! Vimrc BufWritePre <buffer> :%s/\s\+$//e
autocmd! Vimrc InsertLeave,WinEnter * set cursorline
autocmd! Vimrc InsertEnter,WinLeave * set nocursorline
autocmd! Vimrc VimResized * wincmd =

" }}}

" Saner command-line history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Edit file in new tab
map <leader>ef :tabe <cfile><cr>

" Double tap to select whole line
nmap <leader><leader> V

" Dash.app
nmap <silent> <leader>d <Plug>DashSearch

" ALE
nmap <silent> <leader>ff <Plug>(ale_fix)
nmap <silent> <leader>j <Plug>(ale_next_wrap)
nmap <silent> <leader>k <Plug>(ale_previous_wrap)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Saner line movements
nnoremap $ g$
nnoremap 0 g0

" Convert ; to : in modeline
nnoremap ; : " B

" Clear highlight on enter
nnoremap <cr> :nohlsearch<cr><cr>

" Saner behavior of n and N
nnoremap <expr> N 'nN'[v:searchforward]
nnoremap <expr> n 'Nn'[v:searchforward]

" ALE
nnoremap <leader>ae :ALEDetail<cr>
nnoremap <leader>al :ALEToggle<Cr>

" FZF
nnoremap <C-p> :FZF<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>p :History<cr>
nnoremap <leader>s :Startify<cr>
nnoremap <leader>t :Files<cr>
nnoremap <leader>m :Mru<cr>

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
xmap ga <Plug>(EasyAlign)

" Saner block shift
xnoremap < <gv
xnoremap > >gv
