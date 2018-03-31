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
endif

function! plugins#spec() abort
  " {{{ [MINPAC]
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', { 'type': 'opt' })
  " }}}

  call plugins#colorschemes([
        \   'chriskempson/base16-vim',
        \   'ewilazarus/preto',
        \   'fxn/vim-monochrome',
        \   'owickstrom/vim-colors-paramount',
        \   'reedes/vim-colors-pencil',
        \   'xero/blaquemagick.vim',
        \ ] )

  call plugins#opt('reedes/vim-thematic')
  call plugins#opt('bootleq/vim-textobj-rubysymbol')
  call plugins#opt('dbmrq/vim-ditto')
  call plugins#opt('joker1007/vim-ruby-heredoc-syntax')
  call plugins#opt('ludovicchabant/vim-gutentags')
  call plugins#opt('majutsushi/tagbar')
  call plugins#opt('maksimr/vim-jsbeautify')
  call plugins#opt('nelstrom/vim-textobj-rubyblock')
  call plugins#opt('plasticboy/vim-markdown')
  call plugins#opt('reedes/vim-textobj-quote')
  call plugins#opt('reedes/vim-textobj-sentence')
  call plugins#opt('reedes/vim-wordy')
  call plugins#opt('tpope/vim-bundler')
  call plugins#opt('tpope/vim-endwise')
  call plugins#opt('tpope/vim-rails')
  call plugins#opt('tpope/vim-rake')
  call plugins#opt('tpope/vim-rbenv')
  call plugins#opt('vim-ruby/vim-ruby')
  call plugins#opt('vim-scripts/ruby-matchit')
  call plugins#opt('wellle/targets.vim')

  call plugins#start('junegunn/fzf.vim')
  call plugins#start('junegunn/vim-easy-align')
  call plugins#start('kana/vim-textobj-user')
  call plugins#start('mhinz/vim-startify')
  call plugins#start('mileszs/ack.vim')
  call plugins#start('mtth/scratch.vim')
  call plugins#start('nathanaelkane/vim-indent-guides')
  call plugins#start('scrooloose/nerdtree')
  call plugins#start('sheerun/vim-polyglot')
  call plugins#start('sjl/vitality.vim')
  call plugins#start('tpope/vim-abolish')
  call plugins#start('tpope/vim-commentary')
  call plugins#start('tpope/vim-dispatch')
  call plugins#start('tpope/vim-eunuch')
  call plugins#start('tpope/vim-fugitive')
  call plugins#start('tpope/vim-git')
  call plugins#start('tpope/vim-projectionist')
  call plugins#start('tpope/vim-ragtag')
  call plugins#start('tpope/vim-repeat')
  call plugins#start('tpope/vim-sensible')
  call plugins#start('tpope/vim-surround')
  call plugins#start('tpope/vim-unimpaired')
  call plugins#start('vim-airline/vim-airline')
  call plugins#start('vim-airline/vim-airline-themes')
  call plugins#start('vim-scripts/Align')
  call plugins#start('w0rp/ale')
  call plugins#start('yegappan/mru')
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
