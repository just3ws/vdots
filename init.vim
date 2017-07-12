set encoding=utf-8  " The encoding displayed.
scriptencoding=utf-8
set fileencoding=utf-8 nobomb " Ensure utf-8 encoding on write


let g:python_host_prog = expand('$HOME') . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = expand('$HOME') .'/.pyenv/versions/neovim3/bin/python'

call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'beautify-web/js-beautify', { 'do': 'npm install --global js-beautify', 'for': ['javascript', 'coffeescript', 'json'] }
Plug 'maksimr/vim-jsbeautify', { 'for' : ['javascript', 'json', 'javascript.jsx', 'html', 'css', 'scss'] }

Plug 'arcticicestudio/nord-vim'

Plug 'vim-scripts/DeleteTrailingWhitespace'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'Shougo/deoplete.nvim', { 'do' : ':UpdateRemotePlugins' }

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'chrisbra/vim-zsh'

Plug 'dhruvasagar/vim-table-mode', { 'for': ['csv', 'xls', 'xlsx'] } " VIM Table Mode for instant table creation.
Plug 'digitalrounin/vim-yaml-folds', { 'for' : 'yaml' } " YAML, RAML & SaltStack SLS folding for Vim

Plug 'editorconfig/editorconfig-vim'

Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'

Plug 'junegunn/vim-easy-align'
Plug 'vim-scripts/Align'

Plug 'kchmck/vim-coffee-script', { 'do': 'npm install --global coffeelint', 'for' : 'coffeescript' } " CoffeeScript support for Vim
Plug 'roalddevries/yaml.vim', { 'for' : 'yaml' }

Plug 'othree/jspc.vim', { 'for' : ['javascript', 'javascript.jsx', 'coffeescript'] } " JavaScript Parameter Complete

Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/mru.vim'

Plug 'tpope/vim-markdown', { 'for' : 'markdown' } " Vim Markdown runtime files
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' } " Fold markdown documents by section.

Plug 'rizzatti/dash.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on' : ['NERDTree', 'NERDTreeToggle', 'NERDTreeMirror', 'NERDTreeFind'] }
Plug 'sheerun/vim-polyglot' " A solid language pack for Vim.
Plug 'sjl/vitality.vim' " Make Vim play nicely with iTerm 2 and tmux.

Plug 'tpope/vim-abolish' " Easily search for, substitute, and abbreviate multiple variants of a word

Plug 'tpope/vim-bundler', { 'for' : 'ruby' } " Lightweight support for Ruby's Bundler
Plug 'tpope/vim-cucumber', { 'for' : 'cucumber' } " Vim Cucumber runtime files
Plug 'tpope/vim-haml', { 'for' : ['haml', 'sass', 'scss'] } " Vim runtime files for Haml, Sass, and SCSS
Plug 'tpope/vim-projectionist' " Project configuration
Plug 'tpope/vim-rails', { 'for' : ['ruby', 'eruby', 'haml'] } " Ruby on Rails power tools
Plug 'tpope/vim-rake', { 'for' : ['ruby', 'eruby', 'haml'] } " It's like rails.vim without the rails
Plug 'tpope/vim-surround' " Quoting/parenthesizing made simple
Plug 'travisjeffery/vim-auto-mkdir'
Plug 'vim-scripts/ruby-matchit', { 'for' : ['ruby', 'eruby'] }
Plug 'w0rp/ale', { 'do': 'npm install --global tern stylelint' }


Plug 'wesQ3/vim-windowswap'
Plug 'xolox/vim-misc'

Plug 'airblade/vim-gitgutter' " A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'tpope/vim-fugitive' " A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-rhubarb' " GitHub extension for fugitive.vim

Plug 'majutsushi/tagbar'
Plug 'xolox/vim-easytags'

Plug 'coderifous/textobj-word-column.vim'     " Adds text-objects for word-based columns in Vim.
Plug 'gilligan/textobj-gitgutter'             " Vim git change-hunk text object.
Plug 'glts/vim-textobj-comment'               " Vim text objects for comments
Plug 'h1mesuke/textobj-wiw'                   " Text object to select a range of words for humans.
Plug 'jceb/vim-textobj-uri'                   " Text objects for dealing with URIs
Plug 'kana/vim-textobj-datetime'              " Text objects for date and time
Plug 'kana/vim-textobj-diff'                  " Text objects for ouputs of diff(1)
Plug 'kana/vim-textobj-entire'                " Text objects for entire buffer
Plug 'kana/vim-textobj-fold'                  " Text objects for foldings
Plug 'kana/vim-textobj-function'              " Text objects for functions
Plug 'kana/vim-textobj-help'                  " Text objects for Vim help documents
Plug 'kana/vim-textobj-indent'                " Text objects for indented blocks of lines
Plug 'kana/vim-textobj-lastpat'               " Text objects for the last searched pattern
Plug 'kana/vim-textobj-line'                  " Text objects for the current line
Plug 'kana/vim-textobj-syntax'                " Text objects for syntax highlighted items
Plug 'kana/vim-textobj-user'                  " Create your own text objects
Plug 'lucapette/vim-textobj-underscore'       " Underscore text-object for Vim
Plug 'nelstrom/vim-textobj-rubyblock'         " A custom text object for selecting ruby blocks
Plug 'paradigm/TextObjectify'                 " TextObjectify is a Vim plugin which improves text-objects
Plug 'reedes/vim-textobj-quote'               " Use ‘curly’ quote characters in Vim
Plug 'reedes/vim-textobj-sentence'            " Improving on Vim's native sentence text object and motion
Plug 'rhysd/vim-textobj-anyblock'             " A text object for any of single-quote or double-quote pairs, (), {}, [] and <>.
Plug 'rhysd/vim-textobj-ruby'                 " Make text objects with various Ruby block structures.
Plug 'sgur/vim-textobj-parameter'             " Vim plugin to provide text objects for parameters of functions.
Plug 'thinca/vim-textobj-between'             " Text objects for a range between a character.
Plug 'thinca/vim-textobj-function-javascript' " Text objects for functions in javascript.
Plug 'wellle/targets.vim'                     " Vim plugin that provides additional text objects
Plug 'whatyouhide/vim-textobj-erb'            " A vim text object for erb blocks.
Plug 'whatyouhide/vim-textobj-xmlattr'        " A vim text object for XML/HTML attributes.

call plug#end()

let g:airline#extensions#hunks#enabled                     = 0
let g:airline#extensions#quickfix#location_text#enabled    = 0
let g:airline#extensions#quickfix#quickfix_text#enabled    = 0
let g:airline#extensions#tabline#enabled                   = 0
let g:airline#extensions#tabline#formatter#enabled         = 0
let g:airline#extensions#tagbar#enabled                    = 0
let g:airline#extensions#whitespace#enabled                = 0
let g:airline#extensions#windowswap#indicator_text#enabled = 0
let g:airline#extensions#wordcount#filetypes#enabled       = 0

" let g:airline#extensions#ctrlp#show_adjacent_modes=1
" let g:airline#extensions#hunks#hunk_symbols=['+', '~', '-']
" let g:airline#extensions#hunks#non_zero_only=0
" let g:airline#extensions#tabline#left_alt_sep='│' " Right separator for tabline
" let g:airline#extensions#tabline#left_sep=' ' " Left separator for tabline
" let g:airline#extensions#whitespace#checks=[ 'indent', 'trailing', 'long', 'mixed-indent-file' ]
" let g:airline#extensions#whitespace#symbol='!'

" let g:airline_section_y='%{substitute(getcwd(), expand("~"), "~", "g")}' " Set relative path

" │ ║ ░ ▒ ❖ ⟨ ⟩ ⟪ ⟫                   ┊ ┋ ❖ ⬗ ⬖    

let g:airline_left_alt_sep  = ''
let g:airline_left_sep      = ''
let g:airline_right_alt_sep = ''
let g:airline_right_sep     = ''
nnoremap <leader>t :TagbarToggle<cr>

nnoremap <leader>n :NERDTreeToggle<cr>

let g:NERDTreeChDirMode  = 2 " Always change the root directory
let g:NERDTreeMinimalUI  = 1 " Disable help text and bookmark title
let g:NERDTreeShowHidden = 1 " Show hidden files in NERDTree
let g:NERDTreeMouseMode  = 3 " Single click opens directory and file nodes

let g:NERDTreeDirArrowExpandable='▸'
let g:NERDTreeDirArrowCollapsible='▾'

let g:NERDTreeIgnore = [
      \ '\.tags',
      \ '\.DS_Store$',
      \ '\.bundle$',
      \ '\.git$',
      \ '\.sass-cache$',
      \ 'node_modules',
      \ '\.tern-port',
      \ '\.swp$',
      \ '\~$',
      \ 'tmp$',
      \ '\.zwc$'
      \ ]

let g:fugitive_git_executable='LANG=en_US.UTF-8 git'

let g:ackhighlight=1

" let g:ctrlp_match_window='bottom,order:min:1,max:24,results:24'
" let g:ctrlp_prompt_mappings={ 'PrtDeleteEnt()': ['@'] } " Map delete buffer in CtrlP
" let g:ctrlp_custom_ignore={ 'dir':  '\v[\/]\.(git|hg|svn)$\|node_modules$\|backups', 'file': '\v(tags|\.(exe|so|dll|tmp|example))$' }

nnoremap <c-t>. :CtrlPTag<cr>

" if executable('rg')
"   set grepprg=rg\ --color=never
"   let g:ctrlp_user_command='rg %s --files --color=never --glob ""'
"   let g:ctrlp_use_caching=0
" endif

" let g:neomake_ruby_enabled_makers=['rubocop']
" let g:neomake_coffeescript_enabled_makers=['coffeelint']
" let g:neomake_json_enabled_makers=['jsonlint']
" let g:ruby_doc_command='open'
" autocmd! BufWritePost * Neomake

highlight clear ALEErrorSign
highlight clear ALEWarningSign

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" let g:ale_keep_list_window_open=1
" let g:ale_set_loclist=0
" let g:ale_set_quickfix=1
" let g:ale_sign_column_always=1
" let g:ale_open_list=1
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:gitgutter_realtime=0 " Disable GitGutter in realtime
let g:gitgutter_eager=0 " Disable GitGutter to eager load on tab or buffer switch

let g:gitgutter_sign_added='++'
let g:gitgutter_sign_modified='mm'
let g:gitgutter_sign_removed='--'
let g:gitgutter_sign_removed_first_line='^^'
let g:gitgutter_sign_modified_removed='ww'

set tags=./.tags;
" set tagcase=followscs
let g:easytags_dynamic_files=2
let g:easytags_async=1
let g:easytags_always_enabled=1

let g:deoplete#enable_at_startup=1

let g:EditorConfig_exclude_patterns=['fugitive://.*', 'scp://.*']

let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'

let g:NERDCommentEmptyLines=1
let g:NERDCompactSexyComs=1
let g:NERDDefaultAlign='left'
let g:NERDSpaceDelims=1
let g:NERDTrimTrailingWhitespace=1

set termguicolors " Enable 24-bit color mode
set background=dark
colorscheme nord

let g:airline_theme='nord'

let g:webdevicons_enable_airline_tabline=1
let g:webdevicons_enable_airline_statusline=1

nnoremap <leader>rv :w<cr> :source $MYVIMRC<cr> :PlugInstall<cr>
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

set wildignorecase " Ignore case when completing file/dirnames except special characters

set wildmode=list:longest,list:full " Greedy completion

set wildignore=*~,*DS_Store*,*.swp,*.cache
set wildignore+=*.avi,*.m4a,*.mp4,*.mov,*.mp3,*.ogg,*.wmv,*.swf,*part-Frag*
set wildignore+=*.min.js
set wildignore+=*.bz,*.gz,*.tar,*.zip
set wildignore+=*.gem,*sass-cache*,log/**,tmp/**,*.log
set wildignore+=*/images/*,*.gif,*.jpg,*.png,*.ico,*.svg
set wildignore+=*/fonts/*,*.ttf,*.otf,*.woff,*.eot
set wildignore+=tmp/**,*.rbc,.rbx,*.scssc,*.sassc
set wildignore+=bundle/**,vendor/bundle/**,vendor/cache/**,vendor/gems/**
set wildignore+=**/node_modules
set wildignore+=tmp/**,*.pdf
set wildignore+=*/mobile/*,*/mobile_common/* " For Example but need to make this more configurable

set complete=.,w,b,u,i,t
set completeopt=menu,menuone,preview,noinsert,noselect
set infercase " Completion with case-mismatch matches case-insensitive if possible

set scroll=8
set scrolloff=4
set sidescroll=4
set sidescrolloff=4

set shiftwidth=2
set softtabstop=2
set shiftround " Rounds the indentation to a multiple of shiftwidth
set tabstop=2
set expandtab
" set copyindent " Copy the structure of existing lines when autoindenting
" set cindent " Use C rules for indention
" set smartindent " Use language indentation rules where possible

" Keep undo history across sessions, by storing in file.
silent execute '!mkdir -p ~/.local/share/nvim/backup/'
silent execute '!mkdir -p ~/.local/share/nvim/swap/'
silent execute '!mkdir -p ~/.local/share/nvim/undo/'

set backupdir=~/.local/share/nvim/backup//
set directory=~/.local/share/nvim/swap//
set undodir=~/.local/share/nvim/undo//

function! s:LoadLocalVimrc()
  if filereadable(glob(getcwd() . '/.vimrc.local'))
    :execute 'source '.fnameescape(glob(getcwd() . '/.vimrc.local'))
  endif
endfunction

set gdefault " Set global flag for search and replace
" Center highlighted search
nnoremap n nzz
nnoremap N Nzz

" Convert ; to : in modeline
nnoremap ; :

" Clear search on enter key
nnoremap <cr> :nohlsearch<cr><cr>

" If a line is wrapping then step into the wrap line as well.
nnoremap j gj
nnoremap k gk

" Double tap to select whole line
nmap <leader><leader> V

" Highlight last inserted text
nnoremap gV `[v`]

let g:netrw_banner=0

set foldmethod=marker

set title " Change the terminal's title
let &titlestring="%{substitute(expand('%:p'), $HOME, '$HOME', '')}"

set relativenumber " Count based on the relative lines from the cursorline
set number " Show the absolute line number for the cursorline

set history=500 " Store lots of :cmdline history
set showcmd " Show incomplete cmds down the bottom
set noshowmode " Hide showmode because of the powerline plugin
set nocursorline " Don’t use cursorline, as it causes constant redrawing, which, when combined with syntax highlighting, drops performance
set smartcase " Smart case search if there is uppercase
set ignorecase " case insensitive search
set iskeyword+=?,!,@
set mouse=a " Enable mouse usage
set showmatch " Highlight matching bracket
set fileformats+=mac " Add mac format to list
set nowrap
set listchars=tab:␉\ \,trail:·,extends:… ",eol:¬ Set trails for tabs and spaces
set list " Enable listchars
set lazyredraw " Do not redraw on registers and macros
set hidden " Hide buffers in background
set path+=** " Allow recursive search
set nojoinspaces " Use one space, not two, after punctuation.
set virtualedit=block " Allow moving through empty space in virtual mode
set shortmess=aI " Quieter messages and startup

set sessionoptions=winpos,tabpages,help " Save configuration of all tabs and windows

" Expire incomplete/partial key sequences after milliseconds
set ttimeout
set timeoutlen=500
set ttimeoutlen=150

" New buffers to the right and down
set splitright
set splitbelow

set autoread " Read when a file has been changed even outside of Vim.

" Delete comment character when joining commented lines
set formatoptions+=j

set novisualbell
set belloff=all

nnoremap <leader>b :buffers<cr>

augroup vimrc
  autocmd!
augroup END

autocmd vimrc BufNewFile,BufReadPost *.alfredappearance,.jsbeautifyrc,.jshintrc set filetype=json
autocmd vimrc BufNewFile,BufReadPost *.csv set filetype=csv

autocmd vimrc BufWritePre * :DeleteTrailingWhitespace

autocmd vimrc FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
autocmd vimrc FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
autocmd vimrc FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd vimrc FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
autocmd vimrc FileType javascript noremap <buffer> <c-f> :call JsBeautify()<cr>
autocmd vimrc FileType javascript vnoremap <buffer> <c-f> :call RangeJsBeautify()<cr>
autocmd vimrc FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
autocmd vimrc FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
autocmd vimrc FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
autocmd vimrc FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
autocmd vimrc FileType ruby noremap <buffer> <c-f> ggVG=<cr>

autocmd vimrc FileType markdown,txt setlocal spell spelllang=en_us

autocmd vimrc VimEnter,BufNewFile,BufReadPost * call s:LoadLocalVimrc()

autocmd vimrc VimResized * wincmd =

augroup textobj_quote
  autocmd!
augroup END

autocmd textobj_quote FileType markdown call textobj#quote#init()
autocmd textobj_quote FileType textile call textobj#quote#init()
autocmd textobj_quote FileType text call textobj#quote#init({'educate': 0})

" autocmd vimrc vmap <leader>c <esc>:'<,'>:CoffeeCompile<CR>
" autocmd vimrc map <leader>c :CoffeeCompile<CR>
