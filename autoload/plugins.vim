function plugins#init() abort
  call plug#begin($DATA_DIR . '/plugged')

  Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
  Plug 'editorconfig/editorconfig-vim'
  Plug 'sjl/vitality.vim'
  Plug 'tpope/vim-sensible'

  Plug 'ervandew/supertab'

  Plug 'mhinz/vim-startify'
  Plug 'mileszs/ack.vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-git'
  Plug 'tpope/vim-projectionist'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-scripts/align'
  Plug 'w0rp/ale'
  Plug 'yegappan/mru'

  Plug 'gorodinskiy/vim-coloresque'

  Plug 'elzr/vim-json', { 'for': 'json' }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'sebdah/vim-delve', { 'for': 'go' }
  Plug 'tpope/vim-bundler', { 'for': 'ruby' }
  Plug 'tpope/vim-endwise', { 'for': ['ruby', 'sh', 'snippets', 'vim', 'zsh'] }
  Plug 'tpope/vim-ragtag', { 'for': ['html', 'eruby', 'liquid', 'javascript.jsx', 'jsx'] }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  Plug 'tpope/vim-rake', { 'for': 'ruby' }
  Plug 'tpope/vim-rbenv'
  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  Plug 'vim-scripts/ruby-matchit', { 'for': 'ruby' }
  Plug 'wellle/targets.vim'

  Plug 'kien/rainbow_parentheses.vim', { 'for': 'clojure' }
  Plug 'tpope/vim-classpath', { 'for': ['clojure', 'groovy', 'java', 'scala'] }
  Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
  Plug 'venantius/vim-cljfmt', { 'for': 'clojure' }
  Plug 'tpope/vim-salve', { 'for': 'clojure' }
  Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
  Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }

  Plug 'kana/vim-textobj-user'
        \ | Plug 'beloglazov/vim-textobj-quotes'
        \ | Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' }

  Plug '/usr/local/opt/fzf'
        \ | Plug 'junegunn/fzf.vim'

  Plug 'vim-airline/vim-airline'
        \ | Plug 'vim-airline/vim-airline-themes'


  call plug#end()
endfunction


" Plug 'chrisbra/csv.vim'

" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"       \ | Plug 'zchee/deoplete-go', { 'for': 'go', 'do': 'make' }
"       \ | Plug 'Shougo/neco-vim', { 'for': 'vim' }
"       " \ | Plug 'uplus/deoplete-solargraph', { 'for': 'ruby' }

" Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }
"       \ | Plug 'hackhowtofaq/vim-solargraph', { 'for': 'ruby' } " Depends on: vim-projectroot

" Plug 'itchyny/lightline.vim'

" Plug 'Shougo/neocomplcache'
"       \ | Plug 'Shougo/neosnippet.vim'
"       \ | Plug 'Shougo/neosnippet-snippets'

" Plug 'wakatime/vim-wakatime'

" Plug 'cespare/vim-toml', { 'for': 'toml' }
" Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
" Plug 'fatih/vim-go', { 'for': 'go', 'tag': '*', 'do': ':GoInstallBinaries'  }
" Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
" Plug 'nsf/gocode', { 'for': 'go', 'rtp': 'vim', 'do': $DATA_DIR .'/plugged/gocode/vim/symlink.sh' }
" Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
" Plug 'reedes/vim-wordy', { 'for': ['text', 'markdown'] }

" Plug 'sjl/badwolf/'
" Plug 'w0ng/vim-hybrid'
" Plug 'kristijanhusak/vim-hybrid-material'
" Plug 'andreasvc/vim-256noir'
" Plug 'vimwiki/vimwiki'
" Plug 'tpope/vim-sleuth'

" Plug 'dbakker/vim-projectroot'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'majutsushi/tagbar'
" Plug 'mtth/scratch.vim'
" Plug 'nathanaelkane/vim-indent-guides'
