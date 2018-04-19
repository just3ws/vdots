" vim:foldmethod=marker

let g:start_plugins = [
        \ 'Shougo/deoplete.nvim',
        \ 'Shougo/neco-syntax',
        \ 'Shougo/neco-vim',
        \ 'editorconfig/editorconfig-vim',
        \ 'junegunn/fzf.vim',
        \ 'junegunn/vim-easy-align',
        \ 'kana/vim-textobj-user',
        \ 'mhinz/vim-startify',
        \ 'mileszs/ack.vim',
        \ 'mtth/scratch.vim',
        \ 'nathanaelkane/vim-indent-guides',
        \ 'roxma/nvim-yarp',
        \ 'roxma/vim-hug-neovim-rpc',
        \ 'ryanoasis/vim-devicons',
        \ 'scrooloose/nerdtree',
        \ 'sjl/vitality.vim',
        \ 'tpope/vim-abolish',
        \ 'tpope/vim-commentary',
        \ 'tpope/vim-dispatch',
        \ 'tpope/vim-eunuch',
        \ 'tpope/vim-fugitive',
        \ 'tpope/vim-git',
        \ 'tpope/vim-projectionist',
        \ 'tpope/vim-ragtag',
        \ 'tpope/vim-repeat',
        \ 'tpope/vim-scriptease',
        \ 'tpope/vim-sensible',
        \ 'tpope/vim-surround',
        \ 'tpope/vim-unimpaired',
        \ 'uplus/deoplete-solargraph',
        \ 'vim-airline/vim-airline',
        \ 'vim-scripts/Align',
        \ 'w0rp/ale',
        \ 'yegappan/mru',
        \ 'zchee/deoplete-zsh',
        \ ]
let g:opt_plugins = [
        \ 'venantius/vim-cljfmt',
        \ 'venantius/vim-eastwood',
        \ 'bhurlow/vim-parinfer',
        \ 'bootleq/vim-textobj-rubysymbol',
        \ 'chrisbra/vim-zsh',
        \ 'dbmrq/vim-ditto',
        \ 'guns/vim-clojure-highlight',
        \ 'guns/vim-clojure-static',
        \ 'guns/vim-sexp',
        \ 'joker1007/vim-ruby-heredoc-syntax',
        \ 'kien/rainbow_parentheses.vim',
        \ 'leshill/vim-json',
        \ 'ludovicchabant/vim-gutentags',
        \ 'majutsushi/tagbar',
        \ 'maksimr/vim-jsbeautify',
        \ 'mxw/vim-jsx',
        \ 'nelstrom/vim-textobj-rubyblock',
        \ 'pangloss/vim-javascript',
        \ 'plasticboy/vim-markdown',
        \ 'reedes/vim-textobj-quote',
        \ 'reedes/vim-textobj-sentence',
        \ 'reedes/vim-thematic',
        \ 'reedes/vim-wordy',
        \ 'ternjs/tern_for_vim',
        \ 'tpope/vim-bundler',
        \ 'tpope/vim-classpath',
        \ 'tpope/vim-endwise',
        \ 'tpope/vim-fireplace',
        \ 'tpope/vim-leiningen',
        \ 'tpope/vim-rails',
        \ 'tpope/vim-rake',
        \ 'tpope/vim-rbenv',
        \ 'tpope/vim-salve',
        \ 'tpope/vim-sexp-mappings-for-regular-people',
        \ 'vim-ruby/vim-ruby',
        \ 'vim-scripts/ruby-matchit',
        \ 'wellle/targets.vim',
        \ ]

function! plugins#spec() abort
  " {{{ [MINPAC]
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', { 'type': 'opt' })
  " }}}

  call plugins#opts(g:opt_plugins)
  call plugins#starts(g:start_plugins)
endfunction


" {{{ [PLUGINS]
let s:current_file = expand('<sfile>')

if exists('*plugins#reload') | else
  function! plugins#reload() abort
    exec 'source ' . s:current_file

    call plugins#spec()
  endfunction

  function! plugins#start(plugin)
    call minpac#add(a:plugin, { 'type': 'start' })
  endfunction

  function! plugins#opt(plugin)
    call minpac#add(a:plugin, { 'type': 'opt' })
  endfunction

  function! plugins#colorscheme(plugin)
    call plugins#opt(a:plugin)
  endfunction

  function! plugins#colorschemes(plugins)
    for l:plugin in a:plugins
      call plugins#colorscheme(l:plugin)
    endfor
  endfunction

  function! plugins#opts(plugins, ...)
    for l:plugin in a:plugins
      call plugins#opt(l:plugin)
    endfor
  endfunction

  function! plugins#starts(plugins, ...)
    for l:plugin in a:plugins
      call plugins#start(l:plugin)
    endfor
  endfunction
endif
" }}}
