" vim:fdm=marker

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

  function! plugins#opts(message, plugins)
    echomsg '[OPT] ' . a:message
    for l:plugin in a:plugins
      call plugins#opt(l:plugin)
    endfor
  endfunction

  function! plugins#starts(message, plugins)
    echomsg '[STARTS] ' . a:message

    for l:plugin in a:plugins
      call plugins#start(l:plugin)
    endfor
  endfunction
endif
" }}}

function! plugins#spec() abort
  " {{{ [MINPAC]
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', { 'type': 'opt' })
  " }}}

  " 'sheerun/vim-polyglot',
  " moll/vim-node
  call plugins#opts('General Plugins', [
        \   'dbmrq/vim-ditto',
        \   'ludovicchabant/vim-gutentags',
        \   'majutsushi/tagbar',
        \   'maksimr/vim-jsbeautify',
        \   'plasticboy/vim-markdown',
        \   'reedes/vim-textobj-quote',
        \   'reedes/vim-textobj-sentence',
        \   'reedes/vim-thematic',
        \   'reedes/vim-wordy',
        \   'wellle/targets.vim',
        \   'chrisbra/vim-zsh',
        \ ])

  call plugins#opts('Ruby Plugins', [
        \   'nelstrom/vim-textobj-rubyblock',
        \   'bootleq/vim-textobj-rubysymbol',
        \   'joker1007/vim-ruby-heredoc-syntax',
        \   'tpope/vim-bundler',
        \   'tpope/vim-endwise',
        \   'tpope/vim-rails',
        \   'tpope/vim-rake',
        \   'tpope/vim-rbenv',
        \   'vim-ruby/vim-ruby',
        \   'vim-scripts/ruby-matchit',
        \   'vim-ruby/vim-ruby',
        \ ])

  call plugins#starts('Completion Plugins', [
        \   'Shougo/deoplete.nvim',
        \   'Shougo/neco-syntax',
        \   'Shougo/neco-vim',
        \   'roxma/nvim-yarp',
        \   'roxma/vim-hug-neovim-rpc',
        \   'uplus/deoplete-solargraph',
        \   'zchee/deoplete-zsh',
        \ ])

  call plugins#starts('JavaScript/JSON Plugins', [
        \   'leshill/vim-json',
        \   'mxw/vim-jsx',
        \   'pangloss/vim-javascript',
        \   'ternjs/tern_for_vim',
        \ ])

  call plugins#starts('General Plugins', [
        \   'tpope/vim-scriptease',
        \   'editorconfig/editorconfig-vim',
        \   'junegunn/fzf.vim',
        \   'junegunn/vim-easy-align',
        \   'ryanoasis/vim-devicons',
        \   'kana/vim-textobj-user',
        \   'mhinz/vim-startify',
        \   'mileszs/ack.vim',
        \   'mtth/scratch.vim',
        \   'nathanaelkane/vim-indent-guides',
        \   'scrooloose/nerdtree',
        \   'sjl/vitality.vim',
        \   'tpope/vim-abolish',
        \   'tpope/vim-commentary',
        \   'tpope/vim-dispatch',
        \   'tpope/vim-eunuch',
        \   'tpope/vim-fugitive',
        \   'tpope/vim-git',
        \   'tpope/vim-projectionist',
        \   'tpope/vim-ragtag',
        \   'tpope/vim-repeat',
        \   'tpope/vim-sensible',
        \   'tpope/vim-surround',
        \   'tpope/vim-unimpaired',
        \   'vim-airline/vim-airline',
        \   'vim-scripts/Align',
        \   'w0rp/ale',
        \   'yegappan/mru',
        \ ])
endfunction

        " \   'vim-airline/vim-airline-themes',
