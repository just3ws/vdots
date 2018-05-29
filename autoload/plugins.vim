" vim:foldmethod=marker

let g:opt_plugins = [
      \ ]

let g:start_plugins = [
      \ 'editorconfig/editorconfig-vim',
      \ 'wakatime/vim-wakatime'
      \ 'airblade/vim-gitgutter',
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
      \ 'vim-airline/vim-airline',
      \ 'vim-scripts/Align',
      \ 'w0rp/ale',
      \ 'yegappan/mru',
      \ 'chrisbra/vim-zsh',
      \ 'dbmrq/vim-ditto',
      \ 'leshill/vim-json',
      \ 'majutsushi/tagbar',
      \ 'maksimr/vim-jsbeautify',
      \ 'nelstrom/vim-textobj-rubyblock',
      \ 'pangloss/vim-javascript',
      \ 'plasticboy/vim-markdown',
      \ 'reedes/vim-textobj-quote',
      \ 'reedes/vim-textobj-sentence',
      \ 'reedes/vim-thematic',
      \ 'reedes/vim-wordy',
      \ 'ternjs/tern_for_vim',
      \ 'tpope/vim-bundler',
      \ 'tpope/vim-endwise',
      \ 'tpope/vim-rails',
      \ 'tpope/vim-rake',
      \ 'tpope/vim-rbenv',
      \ 'vim-ruby/vim-ruby',
      \ 'vim-scripts/ruby-matchit',
      \ 'wellle/targets.vim',
      \ ]

function! plugins#spec() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', { 'type': 'opt' })

  call plugins#opts(g:opt_plugins)
  call plugins#starts(g:start_plugins)
endfunction


let s:current_file = expand('<sfile>')

if !exists('*plugins#reload')
  function! plugins#reload() abort
    exec 'source ' . s:current_file

    call plugins#spec()
  endfunction

  function! plugins#start(plugin) abort
    call minpac#add(a:plugin, { 'type': 'start' })
  endfunction

  function! plugins#opt(plugin) abort
    call minpac#add(a:plugin, { 'type': 'opt' })
  endfunction

  function! plugins#colorscheme(plugin) abort
    call plugins#opt(a:plugin)
  endfunction

  function! plugins#colorschemes(plugins) abort
    for l:plugin in a:plugins
      call plugins#colorscheme(l:plugin)
    endfor
  endfunction

  function! plugins#opts(plugins, ...) abort
    for l:plugin in a:plugins
      call plugins#opt(l:plugin)
    endfor
  endfunction

  function! plugins#starts(plugins, ...) abort
    for l:plugin in a:plugins
      call plugins#start(l:plugin)
    endfor
  endfunction
endif
