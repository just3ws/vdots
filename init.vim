" vim:fdm=marker ft=vim:

augroup Vimrc
  autocmd!
augroup END

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

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
  source $VDOTS_DIR/vimrc.neovim
else
  source $VDOTS_DIR/vimrc.macvim
endif

source $VDOTS_DIR/vimrc.directories
source $VDOTS_DIR/vimrc.settings

" {{{ [LEADER]
let g:mapleader=';'
let g:maplocalleader=';'
" }}}

" {{{ [MINPAC]
packadd minpac
call minpac#init()

call minpac#add('k-takata/minpac', { 'type': 'opt' })
" }}}

" [[ === CALL MINPAC ADD BELOW === ]]

" {{{ [GENERAL PLUGINS]
call minpac#add('chrisbra/NrrwRgn')
call minpac#add('dbakker/vim-projectroot')
call minpac#add('tpope/vim-abolish')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-dispatch')
call minpac#add('tpope/vim-eunuch')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-sensible')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('yegappan/mru')
" }}}

call minpac#add('Valloric/YouCompleteMe')
call minpac#add('ervandew/supertab') " Use tab for autocompletion; supports both UltiSnips and YouCompleteMe

set omnifunc=syntaxcomplete#Complete

" {{{ [ALIGNMENT]
call minpac#add('junegunn/vim-easy-align')
call minpac#add('vim-scripts/Align')
" }}}

" {{{ [STARTIFY]
call minpac#add('mhinz/vim-startify')

autocmd! Vimrc FileType startify setlocal nofoldenable nolist

let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 1
let g:startify_custom_header = []
let g:startify_enable_unsafe = 1
let g:startify_fortune_use_unicode = 1
let g:startify_recursive_dir = 1
let g:startify_relative_path = 1
let g:startify_update_oldfiles = 1
let g:startify_use_env = 1
let g:startify_padding_left = 4
let g:startify_show_files = 1
let g:startify_files_number = 10
let g:startify_show_sessions = 1
let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence = 1
let g:startify_session_sort = 1
let $STARTIFY_SESSION_DIR = $VIM_CACHE . '/startify/session'
if !isdirectory($STARTIFY_SESSION_DIR)
  call mkdir($STARTIFY_SESSION_DIR, 'p')
endif

let g:startify_session_dir = $STARTIFY_SESSION_DIR
let g:startify_list_order = [
      \ [' === Last modified files in: ' . getcwd() ], 'dir',
      \ [' === Recent files:'], 'files',
      \ [' === Bookmarks:'], 'bookmarks',
      \ [' === Commands:'], 'commands',
      \ [' === Sessions:'], 'sessions'
      \ ]
let g:startify_skiplist = [
      \ $HOME . '/private/*',
      \ $VIMRUNTIME . '/doc',
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
      \  { 'Z': '~/.zshenv'            },
      \  { 't': '~/.tmux.conf'         },
      \  { 'v': $MYVIMRC               }
      \ ]
let g:startify_commands = [
      \ {'p': ':PackUpdate'},
      \ {'P': ':PackClean'},
      \ ]
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
call minpac#add('maksimr/vim-jsbeautify')
call minpac#add('google/vim-maktaba')
call minpac#add('google/vim-codefmt')
call minpac#add('google/vim-glaive')

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
      \ 'python': ['remove_trailing_lines', 'trim_whitespace', 'autopep8', 'isort'],
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
" }}}

" {{{ [SCRATCH BUFFER]
call minpac#add('mtth/scratch.vim')

let g:scratch_persistence_file = $VIM_CACHE . '/scratch.vim'
let g:scratch_filetype = 'text'
let g:scratch_insert_autohide = 0
let g:scratch_autohide = 0
" }}}

" {{{ [GIT]
call minpac#add('tpope/vim-git')
call minpac#add('tpope/vim-fugitive')
" }}}

" {{{ [FZF]
call minpac#add('junegunn/fzf.vim')
call minpac#add('fszymanski/fzf-gitignore')

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
" }}}

" {{{ [VIMGREPPER]
call minpac#add('mhinz/vim-grepper')
" }}}

" {{{ [ACK]
call minpac#add('mileszs/ack.vim')
" }}}

" {{{ [NERDTREE]
call minpac#add('scrooloose/nerdtree')
call minpac#add('Xuyuanp/nerdtree-git-plugin')

autocmd! Vimrc FileType nerdtree setlocal nofoldenable nolist

let g:NERDTreeDirArrows = 1
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeHighlightFolders = 1
let g:NERDTreeHijackNetrw = 1
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
call minpac#add('sirver/ultisnips')
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
" }}}

" {{{ [TAGS]
call minpac#add('ludovicchabant/vim-gutentags')
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
" }}}

" {{{ [EDITORCONFIG]
call minpac#add('editorconfig/editorconfig-vim')

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
" }}}

" {{{ [TEXTOBJS]
call minpac#add('kana/vim-textobj-user')
call minpac#add('reedes/vim-textobj-sentence')
call minpac#add('reedes/vim-textobj-quote')
" }}}

" {{{ [SYNTAX]
call minpac#add('sheerun/vim-polyglot')
" }}}

" {{{ [C#]
call minpac#add('OmniSharp/omnisharp-vim')
" }}}

" {{{ [XML]
autocmd! Vimrc FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" }}}

" {{{ [HTML]
call minpac#add('tpope/vim-ragtag')

autocmd! Vimrc FileType html setlocal omnifunc=htmlcomplete#CompleteTags

let g:html_dynamic_folds = 1
let g:html_no_pre = 1
let g:html_use_css = 1
let g:html_use_encoding = 'UTF-8'
let g:html_no_rendering = 0 " Don't render italic, bold, links in HTML
let g:html_number_lines = 0 " TOhtml don't show line numbers
" }}}

" {{{ [CSS/SCSS]
autocmd! Vimrc FileType css,scss setlocal omnifunc=csscomplete#CompleteCSS
" }}}

" {{{ [RUBY]
call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-rake')
call minpac#add('tpope/vim-rbenv')
call minpac#add('vim-ruby/vim-ruby')
call minpac#add('tpope/vim-endwise')
call minpac#add('nelstrom/vim-textobj-rubyblock')
call minpac#add('vim-scripts/ruby-matchit')
call minpac#add('joker1007/vim-ruby-heredoc-syntax')
call minpac#add('bootleq/vim-textobj-rubysymbol')

autocmd! Vimrc FileType ruby setlocal omnifunc=rubycomplete#Complete

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
let g:ruby_heredoc_syntax_filetypes = {
      \ 'xml': { 'start' : 'XML' },
      \ 'html': { 'start' : 'HTML' },
      \ 'eruby': { 'start' : 'ERB' },
      \ 'pgsql': { 'start' : 'SQL' }
      \ }
" }}}

" {{{ [PYTHON]
call minpac#add('Vimjas/vim-python-pep8-indent')
" }}}

" {{{ [CLOJURE]
" call minpac#add('tpope/vim-leiningen')
" call minpac#add('tpope/vim-fireplace')
" call minpac#add('tpope/vim-classpath')
" call minpac#add('tpope/vim-salve')
" call minpac#add('guns/vim-sexp')
" call minpac#add('tpope/vim-sexp-mappings-for-regular-people')
" }}}

" {{{ [ELIXIR/ERLANG]
call minpac#add('vim-erlang/vim-erlang-runtime')
call minpac#add('vim-erlang/vim-erlang-compiler')
call minpac#add('vim-erlang/vim-erlang-omnicomplete')
call minpac#add('vim-erlang/vim-erlang-tags')
call minpac#add('elixir-editors/vim-elixir')   " Better language support (more than polyglot)
call minpac#add('slashmili/alchemist.vim')     " Enhanced Elixir integration for Vim
call minpac#add('andyl/vim-textobj-elixir')    " Add text object for Elixir blocks

let g:elixir_use_markdown_for_docs = 1
" }}}

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

" {{{ [JAVASCRIPT]
autocmd! Vimrc FileType javascript setlocal omnifunc=tern#Complete
" }}}

" {{{ [GOLANG]
call minpac#add('fatih/vim-go')
" }}}

source $VDOTS_DIR/vimrc.commands
source $VDOTS_DIR/vimrc.autocmds
source $VDOTS_DIR/vimrc.mappings
source $VDOTS_DIR/vimrc.theme
