" vi: foldmethod=marker

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

  function! plugins#opts(plugins)
    for l:plugin in a:plugins
      call plugins#opt(l:plugin)
    endfor
  endfunction

  function! plugins#starts(plugins)
    for l:plugin in a:plugins
      call plugins#start(l:plugin)
    endfor
  endfunction
endif

function! plugins#spec() abort
  " {{{ [MINPAC]
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', { 'type': 'opt' })
  " }}}

  " 'rafi/awesome-vim-colorschemes',
  call plugins#colorschemes([
        \   'NLKNguyen/papercolor-theme',
        \   'arcticicestudio/nord-vim',
        \   'chriskempson/base16-vim',
        \   'ewilazarus/preto',
        \   'fxn/vim-monochrome',
        \   'jacoborus/tender.vim',
        \   'kristijanhusak/vim-hybrid-material',
        \   'owickstrom/vim-colors-paramount',
        \   'reedes/vim-colors-pencil',
        \   'robertmeta/nofrils',
        \   'sonph/onehalf',
        \   'tyrannicaltoucan/vim-deep-space',
        \   'tyrannicaltoucan/vim-quantum',
        \   'whatyouhide/vim-gotham',
        \   'xero/blaquemagick.vim',
        \ ])

  call plugins#opts([
        \   'bootleq/vim-textobj-rubysymbol',
        \   'dbmrq/vim-ditto',
        \   'joker1007/vim-ruby-heredoc-syntax',
        \   'ludovicchabant/vim-gutentags',
        \   'majutsushi/tagbar',
        \   'maksimr/vim-jsbeautify',
        \   'nelstrom/vim-textobj-rubyblock',
        \   'plasticboy/vim-markdown',
        \   'reedes/vim-textobj-quote',
        \   'reedes/vim-textobj-sentence',
        \   'reedes/vim-thematic',
        \   'reedes/vim-wordy',
        \   'tpope/vim-bundler',
        \   'tpope/vim-endwise',
        \   'tpope/vim-rails',
        \   'tpope/vim-rake',
        \   'tpope/vim-rbenv',
        \   'vim-ruby/vim-ruby',
        \   'vim-scripts/ruby-matchit',
        \   'wellle/targets.vim',
        \ ])

  call plugins#starts([
        \   'junegunn/fzf.vim',
        \   'junegunn/vim-easy-align',
        \   'ryanoasis/vim-devicons',
        \   'kana/vim-textobj-user',
        \   'mhinz/vim-startify',
        \   'mileszs/ack.vim',
        \   'mtth/scratch.vim',
        \   'nathanaelkane/vim-indent-guides',
        \   'scrooloose/nerdtree',
        \   'sheerun/vim-polyglot',
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
        \   'vim-airline/vim-airline-themes',
        \   'vim-scripts/Align',
        \   'w0rp/ale',
        \   'yegappan/mru',
        \ ])
endfunction

" {{{ [OTHER PLUGINS]
" AndrewRadev/splitjoin.vim
" MarcWeber/vim-addon-mw-utils
" OmniSharp/omnisharp-vim
" Shougo/neco-vim
" Valloric/YouCompleteMe'
" Vimjas/vim-python-pep8-indent
" Xuyuanp/nerdtree-git-plugin
" andyl/vim-textobj-elixir
" andymass/vim-matchup'
" cespare/vim-toml
" chrisbra/NrrwRgn
" dag/vim-fish
" dbakker/vim-projectroot
" direnv/direnv.vim
" editorconfig/editorconfig-vim
" elixir-editors/vim-elixir
" elixir-lang/vim-elixir
" ervandew/supertab
" fatih/vim-go
" fszymanski/fzf-gitignore
" garbas/vim-snipmate
" google/vim-codefmt
" google/vim-glaive
" google/vim-maktaba
" guns/vim-sexp
" hauleth/asyncdo.vim
" hauleth/blame.vim
" hauleth/sad.vim
" honza/vim-snippets
" idanarye/vim-merginal
" jiangmiao/auto-pairs
" justinmk/vim-dirvish
" kassio/neoterm
" keremc/asyncomplete-racer.vim
" kopischke/vim-fetch
" mbbill/undotree
" mhinz/vim-grepper
" mhinz/vim-startify
" mjbrownie/swapit
" pangloss/vim-javascript
" parkr/vim-jekyll
" prabirshrestha/async.vim
" prabirshrestha/asyncomplete-necovim.vim
" prabirshrestha/asyncomplete.vim
" rizzatti/dash.vim
" romainl/vim-qf
" romainl/vim-qlist
" rust-lang/rust.vim
" ryanoasis/vim-devicons
" sirver/ultisnips
" skywind3000/asyncrun.vim
" slashmili/alchemist.vim
" t9md/vim-choosewin
" tommcdo/vim-exchange
" tommcdo/vim-lion
" tomtom/tlib_vim
" tpope/vim-classpath
" tpope/vim-fireplace
" tpope/vim-jdaddy
" tpope/vim-leiningen
" tpope/vim-liquid
" tpope/vim-projectionist
" tpope/vim-repeat
" tpope/vim-salve
" tpope/vim-sexp-mappings-for-regular-people
" tpope/vim-surround
" tpope/vim-unimpaired
" vim-erlang/vim-erlang-compiler
" vim-erlang/vim-erlang-omnicomplete
" vim-erlang/vim-erlang-runtime
" vim-erlang/vim-erlang-tags
" yami-beta/asyncomplete-omni.vim
" }}}
