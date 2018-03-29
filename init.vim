" vim:fdm=marker ft=vim:

augroup Vimrc
  autocmd!
augroup END

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

command! -bar PackUpdate call plugins#reload() | call minpac#update()
command! -bar PackClean  call plugins#reload() | call minpac#clean()

if has('nvim')
  let $VIM_DIR = '/nvim'
else
  let $VIM_DIR = '/vim'
endif

let $XDG_CACHE_HOME = expand($HOME . '/.cache')
let $XDG_CONFIG_HOME = expand($HOME . '/.config')
let $XDG_DATA_HOME = expand($HOME . '/.local/share')
let $VDOTS_DIR = expand($XDG_CONFIG_HOME . '/vdots')
let $VIM_HOME = expand($XDG_DATA_HOME . $VIM_DIR)
let $VIM_CACHE = expand($XDG_CACHE_HOME . $VIM_DIR)

let $BACKUP_DIR = $VIM_HOME . '/backup'
let $SWAP_DIR = $VIM_HOME . '/swap'
let $UNDO_DIR = $VIM_HOME . '/undo'
let $VIEW_DIR = $VIM_HOME . '/view'

if has('nvim')
  let g:ruby_host_prog = '/usr/local/bin/ruby'
  let g:python2_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/local/bin/python3'

  if !isdirectory($VIM_HOME . '/shada')
    call mkdir($VIM_HOME . '/shada', 'p')
  endif

  " ' - Maximum number of previously edited files marks
  " < - Maximum number of lines saved for each register
  " @ - Maximum number of items in the input-line history to be
  " s - Maximum size of an item contents in KiB
  " h - Disable the effect of 'hlsearch' when loading the shada
  set shada='300,<10,@50,s100,h

  " Incremental everything
  set inccommand=

  " Write history on idle, for sharing among different sessions
  autocmd! Vimrc CursorHold * if exists(':rshada') | rshada | wshada | endif
else
  set viminfo='100,n$VIM_HOME/viminfo
endif

if !isdirectory($VIM_HOME)
  call mkdir($VIM_HOME, 'p')
endif

if !isdirectory($VIM_CACHE)
  call mkdir(expand($VIM_CACHE), 'p')
endif

if !isdirectory($BACKUP_DIR)
  call mkdir($BACKUP_DIR, 'p')
endif

if !isdirectory($SWAP_DIR)
  call mkdir($SWAP_DIR, 'p')
endif

if !isdirectory($UNDO_DIR)
  call mkdir($UNDO_DIR, 'p')
endif

if !isdirectory($VIEW_DIR)
  call mkdir($VIEW_DIR, 'p')
endif

if !exists('g:syntax_on')
  syntax enable
endif

filetype on
filetype indent on
filetype plugin on

set backupdir=$BACKUP_DIR//
set directory=$SWAP_DIR//
set undodir=$UNDO_DIR//
set viewdir=$VIEW_DIR//

" === BACKUP SETTINGS ===
" turn backup OFF
" Normally we would want to have it turned on. See bug and workaround below.
" OBS: It's a known-bug that backupdir is not supporting
" the correct double slash filename expansion
" see: https://code.google.com/p/vim/issues/detail?id=179
set nobackup

" set a centralized backup directory
" set backupdir=~/.vim/backup//
" set writebackup " Make a backup of the original file when writing
" set backup
set backupskip+=*.log " Don't backup log files

" This is the workaround for the backup filename expansion problem.
autocmd! Vimrc BufWritePre * :call SaveBackups()

function! SaveBackups()
if expand('%:p') =~ &backupskip | return | endif

" If this is a newly created file, don't try to create a backup
if !filereadable(@%) | return | endif

for l:backupdir in split(&backupdir, ',')
  :call SaveBackup(l:backupdir)
endfor
endfunction

function! SaveBackup(backupdir)
let l:filename = expand('%:p')
if a:backupdir =~? '//$'
  let l:backup = escape(substitute(l:filename, '/', '%', 'g')  . &backupext, '%')
else
  let l:backup = escape(expand('%') . &backupext, '%')
endif

let l:backup_path = a:backupdir . l:backup

:silent! execute '!cp ' . resolve(l:filename) . ' ' . l:backup_path
endfunction

set autoindent " Overwritten by cindent or filetype rules
set autoread " Read when a file has been changed even outside of Vim.
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
set listchars=tab:␉\ \,trail:·,extends:…
set magic
set maxmempattern=2000000
set modeline " Automatically setting options from modelines
set modelines=1
set mouse=a
set noautochdir
set nocursorcolumn
set nocursorline " Don’t use cursorline, as it causes constant redrawing, which, when combined with syntax highlighting, drops performance
set noerrorbells
set noexrc
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
set synmaxcol=1000
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
set virtualedit=block " Position cursor anywhere in visual block
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
set wildmode=longest,list:full " http://stackoverflow.com/a/526940/5228839
set wildoptions=tagfile
set wrapscan

let g:mapleader=';'
let g:maplocalleader=';'

packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', { 'type': 'opt' })

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
      \ 'html': ['htmlhint', 'tidy'],
      \ 'liquid': ['htmlhint', 'tidy'],
      \ 'javascript': ['standard'],
      \ 'markdown': ['mdl', 'alex'],
      \ 'go': ['golint', 'go vet'],
      \ 'ruby': ['rubocop', 'ruby'],
      \ 'scss': ['stylelint'],
      \ 'vim': ['vint'],
      \ }

let g:ale_fixers = {
      \ 'css': ['prettier'],
      \ 'go': ['gofmt'],
      \ 'javascript': ['prettier'],
      \ 'json': ['prettier'],
      \ 'markdown': ['prettier'],
      \ 'python': ['autopep8', 'isort'],
      \ 'ruby': ['rubocop'],
      \ 'sass': ['prettier'],
      \ 'scss': ['prettier'],
      \ 'vim': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'xml': ['prettier']
      \ }
" \ 'yaml': ['yamllint'],
let g:ale_pattern_options = {
      \ '\.min\.js$': { 'ale_linters': [], 'ale_fixers': [] },
      \ '\.min\.css$': { 'ale_linters': [], 'ale_fixers': [] },
      \ }
let g:ale_python_autopep8_options = '-aa'
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es6'
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_html_tidy_options = '-q -e -language en -utf8 --show-body-only 1'
highlight clear ALEErrorSign
highlight clear ALEWarningSign
" Automatically close corresponding loclist when quitting a window
autocmd! Vimrc QuitPre * if &filetype != 'qf' | silent! lclose | endif

let g:scratch_persistence_file = $VIM_CACHE . '/scratch.vim'
let g:scratch_filetype = 'text'
let g:scratch_insert_autohide = 0
let g:scratch_autohide = 0


set runtimepath+=/usr/local/opt/fzf

let $FZF_HISTORY_DIR = $VIM_CACHE . '/fzf/history'

if !isdirectory($FZF_HISTORY_DIR)
  call mkdir($FZF_HISTORY_DIR, 'p')
endif

let g:fzf_history_dir = $FZF_HISTORY_DIR

let g:fzf_layout = { 'window': 'new' }
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }



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

let g:indent_guides_auto_colors = 1
let g:indent_guides_default_mapping = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'startify', 'markdown', 'tagbar']
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
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
        \ 'kinds': [
        \   'm:modules',
        \   'c:classes',
        \   'C:constants',
        \   'F:singleton methods',
        \   'f:methods',
        \   'a:aliases'
        \ ],
        \ 'kind2scope': { 'c': 'class', 'm': 'class' },
        \ 'scope2kind': { 'class': 'c' },
        \ 'ctagsbin': 'ripper-tags',
        \ 'ctagsargs': ['-f', '-']
        \ }
endif


let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

let g:html_dynamic_folds = 1
let g:html_no_pre = 1
let g:html_use_css = 1
let g:html_use_encoding = 'UTF-8'
let g:html_no_rendering = 0 " Don't render italic, bold, links in HTML
let g:html_number_lines = 0 " TOhtml don't show line numbers


let g:elixir_use_markdown_for_docs = 1
let g:vim_markdown_folding_disabled = 1

command! Vimrc Reload     :execute ':write ' . $MYVIMRC.' | :source ' . $MYVIMRC
command! Vimrc PackUpdate :packadd minpac | :source $MYVIMRC | :call minpac#update()
command! Vimrc PackClean  :packadd minpac | :source $MYVIMRC | :call minpac#clean()

command! Vimrc Aliasrc   :edit $XDG_CONFIG_HOME/zsh/.aliasrc
command! Vimrc Antigenrc :edit $XDG_CONFIG_HOME/zsh/.antigenrc
command! Vimrc Vimrc     :edit $MYVIMRC
command! Vimrc Zpromptrc :edit $XDG_CONFIG_HOME/zsh/.zpromptrc
command! Vimrc Zshenv    :edit $HOME/.zshenv
command! Vimrc Zshrc     :edit $XDG_CONFIG_HOME/zsh/.zshrc

command! Vimrc Valiasrc   :vsplit $XDG_CONFIG_HOME/zsh/.aliasrc
command! Vimrc Vantigenrc :vsplit $XDG_CONFIG_HOME/zsh/.antigenrc
command! Vimrc Vvimrc     :vsplit $MYVIMRC
command! Vimrc Vzpromptrc :vsplit $XDG_CONFIG_HOME/zsh/.zpromptrc
command! Vimrc Vzshenv    :vsplit $HOME/.zshenv
command! Vimrc Vzshrc     :vsplit $XDG_CONFIG_HOME/zsh/.zshrc

command! Vimrc Saliasrc   :split $XDG_CONFIG_HOME/zsh/.aliasrc
command! Vimrc Santigenrc :split $XDG_CONFIG_HOME/zsh/.antigenrc
command! Vimrc Svimrc     :split $MYVIMRC
command! Vimrc Szpromptrc :split $XDG_CONFIG_HOME/zsh/.zpromptrc
command! Vimrc Szshenv    :split $HOME/.zshenv
command! Vimrc Szshrc     :split $XDG_CONFIG_HOME/zsh/.zshrc

command! Vimrc Taliasrc   :tabedit $XDG_CONFIG_HOME/zsh/.aliasrc
command! Vimrc Tantigenrc :tabedit $XDG_CONFIG_HOME/zsh/.antigenrc
command! Vimrc Tvimrc     :tabedit $MYVIMRC
command! Vimrc Tzpromptrc :tabedit $XDG_CONFIG_HOME/zsh/.zpromptrc
command! Vimrc Tzshenv    :tabedit $HOME/.zshenv
command! Vimrc Tzshrc     :tabedit $XDG_CONFIG_HOME/zsh/.zshrc

if has('gui_running')
  command! Vimrc Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
  command! Vimrc Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
endif
autocmd! Vimrc BufWritePre <buffer> :%s/\s\+$//e
autocmd! Vimrc InsertLeave,WinEnter * setlocal cursorline
autocmd! Vimrc InsertEnter,WinLeave * setlocal nocursorline
autocmd! Vimrc VimResized * wincmd =
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
" nmap <silent> <leader>ff <Plug>(ale_fix)

nmap <silent> <leader>j <Plug>(ale_next_wrap)
nmap <silent> <leader>k <Plug>(ale_previous_wrap)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Saner line movements
nnoremap $ g$
nnoremap 0 g0

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
nnoremap <leader>al :ALEToggle<Cr>

autocmd! Vimrc FileType css,scss,markdown,javascript,xml noremap <buffer> <leader>ff :ALEFix<cr>
autocmd! Vimrc FileType html,liquid noremap <buffer> <leader>ff :call HtmlBeautify()<cr>

" map <c-f> :call JsBeautify()<cr>
" autocmd! Vimrc FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" autocmd! Vimrc FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" autocmd! Vimrc FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
" autocmd! Vimrc FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" autocmd! Vimrc FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
" autocmd! Vimrc FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
" autocmd! Vimrc FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
" autocmd! Vimrc FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
" autocmd! Vimrc FileType html,liquid vnoremap <buffer> <leader>ff :call RangeHtmlBeautify()<cr>
" autocmd! Vimrc FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>

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
xmap ga <Plug>(EasyAlign)

" Saner block shift
xnoremap < <gv
xnoremap > >gv

" Change directory to project root
nnoremap <leader>dp :ProjectRootCD<cr>
" Open NERDTree at project root
nnoremap <silent> <leader>dt :ProjectRootExe NERDTreeFind<cr>

set background=dark

if has('gui_running')
  set guifont=FiraCode-Retina:h18
endif

if has('termguicolors')
  set termguicolors
else
  set t_Co=256
endif

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1
let g:airline_left_sep='' " 
let g:airline_left_alt_sep='' " 
let g:airline_right_sep='' " 
let g:airline_right_alt_sep='' " 

let g:airline_theme = 'base16_tomorrow'

let g:base16colorspace = 256

colorscheme base16-tomorrow-night

set omnifunc=syntaxcomplete#Complete

" autocmd! User Startified setlocal nocursorline nofoldenable nolist
" rgb(35,35,35) == #232323 the color of MacOS dark menu
