" vim:set filetype=vim expandtab shiftwidth=2:

" Python Integration {{{1

let g:python_host_prog = expand('$HOME') . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = expand('$HOME') .'/.pyenv/versions/neovim3/bin/python'

" }}}1

" Plugins {{{1

call plug#begin('~/.local/share/nvim/site/plugged')

" Pre-requisites {{{2

Plug 'beautify-web/js-beautify', { 'do': 'npm install -g js-beautify', 'for': ['javascript', 'coffeescript', 'json'] }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install' }

" }}}2

Plug 'Shougo/deoplete.nvim', { 'do' : ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
Plug 'chrisbra/vim-zsh'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dhruvasagar/vim-table-mode', { 'for': ['csv', 'xls', 'xlsx'] }
Plug 'digitalrounin/vim-yaml-folds', { 'for' : 'yaml' }
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'jceb/vim-textobj-uri'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'kchmck/vim-coffee-script', { 'for' : 'coffeescript' }
Plug 'lucapette/vim-textobj-underscore'
Plug 'majutsushi/tagbar'
Plug 'maksimr/vim-jsbeautify', { 'for' : ['javascript', 'json', 'javascript.jsx', 'html', 'css', 'scss'] }
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }
Plug 'nelstrom/vim-textobj-rubyblock', { 'for' : ['ruby', 'eruby'] }
Plug 'othree/jspc.vim', { 'for' : ['javascript', 'javascript.jsx', 'coffeescript'] }
Plug 'reedes/vim-textobj-quote'
Plug 'reedes/vim-textobj-sentence'
Plug 'roalddevries/yaml.vim', { 'for' : 'yaml' }
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on' : ['NERDTree', 'NERDTreeToggle', 'NERDTreeMirror', 'NERDTreeFind'] }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler', { 'for' : 'ruby' }
Plug 'tpope/vim-cucumber', { 'for' : 'cucumber' }
Plug 'vim-scripts/gitignore.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-haml', { 'for' : 'haml' }
Plug 'tpope/vim-markdown', { 'for' : 'markdown' }
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails', { 'for' : ['ruby', 'eruby', 'haml'] }
Plug 'tpope/vim-rake', { 'for' : ['ruby', 'eruby', 'haml'] }
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'travisjeffery/vim-auto-mkdir'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby', { 'for' : ['ruby', 'eruby'] }
Plug 'vim-scripts/mru.vim'
Plug 'vim-scripts/ruby-matchit', { 'for' : ['ruby', 'eruby'] }
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'wesQ3/vim-windowswap'
Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'

call plug#end()

" }}}1

" Plugin Configuration {{{1

" JsBeautify {{{2

autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>

" for json
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>

" for jsx
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>

" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>

" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

" }}}2

" Airline {{{2

let g:airline#extensions#ctrlp#show_adjacent_modes = 1

let g:airline#extensions#tagbar#enabled = 1

let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
let g:airline#extensions#hunks#non_zero_only = 0

let g:airline#extensions#tabline#enabled=1 " Enable tabline extension
let g:airline#extensions#tabline#left_alt_sep='│' " Right separator for tabline
let g:airline#extensions#tabline#left_sep=' ' " Left separator for tabline

let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#checks = [
      \ 'indent',
      \ 'trailing',
      \ 'long',
      \ 'mixed-indent-file'
      \ ]
let g:airline#extensions#whitespace#symbol = '!'

let g:airline_section_y='%{substitute(getcwd(), expand("~"), "~", "g")}' " Set relative path

" │ ║ ░ ▒ ❖ ⟨ ⟩ ⟪ ⟫                   ┊ ┋ ❖ ⬗ ⬖    

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''

let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" }}}2

" DevIcons {{{

let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

" }}}2

" Tagbar {{{2

nnoremap <leader>t :TagbarToggle<cr>

" }}}2

" NERDTree {{{2

" Open NERDTree

nnoremap <leader>n :NERDTreeToggle<cr>

let g:NERDTreeChDirMode=2 " Always change the root directory
let g:NERDTreeMinimalUI=1 " Disable help text and bookmark title
let g:NERDTreeShowHidden=1 " Show hidden files in NERDTree
let g:NERDTreeMouseMode=3 " Single click opens directory and file nodes

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:NERDTreeIgnore=[
      \ 'tags',
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

" }}}2

" Fugitive {{{2

let g:fugitive_git_executable="LANG=en_US.UTF-8 git"

" }}}2

let g:ackhighlight=1

" EditorConfig {{{2

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" }}}2

" CtrlP {{{2

let g:ctrlp_match_window = 'bottom,order:min:1,max:24,results:24'
let g:ctrlp_prompt_mappings = { 'PrtDeleteEnt()': ['@'] } " Map delete buffer in CtrlP
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$\|node_modules$\|backups',
      \ 'file': '\v(tags|\.(exe|so|dll|tmp|example))$'
      \ }

nnoremap <c-t>. :CtrlPTag<cr>

" }}}2

" Neomake {{{2

" let g:neomake_ruby_enabled_makers = ['rubocop']
" let g:neomake_coffeescript_enabled_makers = ['coffeelint']
" let g:neomake_json_enabled_makers = ['jsonlint']
" let g:ruby_doc_command='open'
" autocmd! BufWritePost * Neomake

" }}}2

" ALE {{{2

highlight clear ALEErrorSign
highlight clear ALEWarningSign"
" 🚑
let g:ale_statusline_format = ['💢 %d', '💩 %d', '👌 ok']
let g:ale_sign_error = '💢'
let g:ale_sign_warning = '💩'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" let g:ale_keep_list_window_open = 1
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1
" let g:ale_sign_column_always = 1
" let g:ale_open_list = 1
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

" }}}2

" GitGutter {{{2

let g:gitgutter_realtime = 0 " Disable GitGutter in realtime
let g:gitgutter_eager = 0 " Disable GitGutter to eager load on tab or buffer switch

let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = 'mm'
let g:gitgutter_sign_removed = '--'
let g:gitgutter_sign_removed_first_line = '^^'
let g:gitgutter_sign_modified_removed = 'ww'

" }}}2

" EasyTags {{{2

set tags=./tags;
" set tagcase=followscs
let g:easytags_dynamic_files = 2

" }}}2

" Deoplete {{{2

let g:deoplete#enable_at_startup = 1

" }}}2

" ripgrep {{{2

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

set grepprg=rg\ --vimgrep

" }}}2

" fzf {{{2

set rtp+=/usr/local/opt/fzf

" }}}2

" EditorConfig {{{2

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" }}}2

" UltiSnips {{{2

let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'

" }}}2

" nerdcommenter {{{

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_ruby = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" }}}2

" }}}1

" Theme {{{1

" Colors {{{2

set termguicolors " Enable 24-bit color mode
set background=dark
colorscheme base16-tomorrow-night

" }}}2

" base16 {{{2

let base16colorspace=256

" }}}2

" Airline {{{2

let g:airline_theme="base16_tomorrow"

" }}}2

" Font styles {{{2

let g:enable_bold_font=1
let g:airline_powerline_fonts=1
highlight Comment cterm=italic gui=italic

" }}}2


" }}}1

" Edit Vim settings {{{1

nnoremap <leader>rv :w<cr> :source $MYVIMRC<cr> :PlugInstall<cr>
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" }}}1

" Common Settings {{{1

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
set fileencoding=utf-8 nobomb " Ensure utf-8 encoding on write
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
set vb t_vb=

" }}}1

" Completion {{{1

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
set wildignore+=*/mobile/*,*/mobile_common/* " For BenchPrep but need to make this more configurable

set complete=.,w,b,u,i,t
set completeopt=menu,menuone,preview,noinsert,noselect
set infercase " Completion with case-mismatch matches case-insensitive if possible

" }}}1

"Scrolling {{{1

set scroll=8
set scrolloff=4
set sidescroll=4
set sidescrolloff=4

" }}}1

" Indentation {{{1

set shiftwidth=2
set softtabstop=2
set shiftround " Rounds the indentation to a multiple of shiftwidth
set tabstop=2
set expandtab
set copyindent " Copy the structure of existing lines when autoindenting
set cindent " Use C rules for indention
set smartindent " Use language indentation rules where possible

" }}}1
"
" Undo {{{1

" Keep undo history across sessions, by storing in file.

silent execute '!mkdir -p ~/.local/share/nvim/backup/'
silent execute '!mkdir -p ~/.local/share/nvim/swap/'
silent execute '!mkdir -p ~/.local/share/nvim/undo/'

set backupdir=~/.local/share/nvim/backup//
set directory=~/.local/share/nvim/swap//
set undodir=~/.local/share/nvim/undo//

" }}}1

" Convert ; to : in modeline
nnoremap ; :

" Functions {{{1

function! s:StripTrailingWhitespaces()
  let l:l=line(".")
  let l:c=col(".")
  %s/\s\+$//e
  call cursor(l:l, l:c)
endfunction

function! s:LoadLocalVimrc()
  if filereadable(glob(getcwd() . '/.vimrc.local'))
    :execute 'source '.fnameescape(glob(getcwd() . '/.vimrc.local'))
  endif
endfunction

" }}}1

" Find {{{1

set gdefault " Set global flag for search and replace
" Center highlighted search
nnoremap n nzz
nnoremap N Nzz

" }}}1

" augroup vimrc {{{1

augroup vimrc
  autocmd!
augroup END

autocmd vimrc BufWritePre * :call s:StripTrailingWhitespaces()              " Auto-remove trailing spaces
" autocmd vimrc FileType html,javascript,coffee,ruby setlocal sw=2 sts=2 ts=2 " Set 2 indent for html
" autocmd vimrc FileType javascript setlocal cc=80                            " Set right margin only for php and js
autocmd vimrc FileType markdown setlocal spell spelllang=en_us
autocmd vimrc FileType srt setlocal spell spelllang=en_us
autocmd vimrc FileType txt setlocal spell spelllang=en_us
autocmd vimrc VimEnter,BufNewFile,BufReadPost * call s:LoadLocalVimrc()     " Load per project vimrc (Used for custom test mappings, etc.)

autocmd vimrc VimEnter * set vb t_vb=

" }}}1

 " Clear search on enter key
nnoremap <cr> :nohlsearch<cr><cr>

" If a line is wrapping then step into the wrap line as well.
nnoremap j gj
nnoremap k gk

" Double tap to select whole line
nmap <leader><leader> V

" Highlight last inserted text
nnoremap gV `[v`]


" Automatically equalize window sizes when Vim window is resized
autocmd VimResized * wincmd =

" recognize files ending in .csv as csv files
autocmd BufNewFile,BufReadPost *.csv set filetype=csv

let g:netrw_banner  = 0

" autocmd BufWritePre <buffer> set et|retab
