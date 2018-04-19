" {{{ [Ruby, Rake, and RSpec]

augroup FT_RUBY
  autocmd!
augroup END

autocmd! FT_RUBY BufRead,BufNewFile [rR]akefile,*.rake setfiletype ruby.rake

autocmd! FT_RUBY BufNewFile,BufRead Gemfile,Gemfile.lock setfiletype ruby.rails.bundler
autocmd! FT_RUBY BufEnter Gemfile,Gemfile.lock setfiletype ruby.rails.bundler

autocmd! FT_RUBY BufRead,BufNewFile *_spec.rb setfiletype ruby.rspec

autocmd! FT_RUBY BufNewFile,BufRead *.{erb,rhtml,ecr,mobile*} setfiletype eruby
autocmd! FT_RUBY BufEnter,BufNewFile *.{arb,builder,cap,gem,gemspec,god,jbuilder,opal,podspec,rabl,rb,rb2,rbw,rjs,ru,ruby,rxml,step,thor} setfiletype ruby
autocmd! FT_RUBY BufEnter,BufNewFile .{autotest,simplecov} setfiletype ruby
autocmd! FT_RUBY BufEnter,BufNewFile {.,}pryrc,{.,}irbrc  setfiletype ruby
autocmd! FT_RUBY BufEnter,BufNewFile {[cC]apfile,[tT]horfile} setfiletype ruby
autocmd! FT_RUBY BufEnter,BufNewFile {Appraisals,Berksfile,Brewfile,Buildfile,Cheffile,Guardfile,KitchenSink,Podfile,Puppetfile,Thorfile,Vagrantfile} setfiletype ruby

" }}}

" {{{ [Git]

augroup FT_GIT
  autocmd!
augroup END

autocmd! FT_GIT BufRead,BufNewFile MERGE_MSG setfiletype gitcommit
autocmd! FT_GIT BufRead,BufNewFile *.gitconfig setfiletype gitconfig
autocmd! FT_GIT BufRead,BufNewFile COMMIT_EDITMSG setfiletype gitcommit

" }}}

" {{{ [HOSTS]

augroup FT_HOSTS
  autocmd!
augroup END

autocmd! FT_HOSTS BufRead,BufNewFile */etc/host.conf setfiletype hostconf
autocmd! FT_HOSTS BufRead,BufNewFile /private/etc/hosts,/etc/hosts setfiletype hostaccess

" }}}

" {{{ [tmux]

augroup FT_TMUX
  autocmd!
augroup END

autocmd! FT_TMUX BufRead,BufNewFile {.,}tmux*.conf* setfiletype tmux

" }}}

" {{{ [Markdown]

augroup FT_MARKDOWN
  autocmd!
augroup END

autocmd! FT_MARKDOWN BufRead,BufNewFile *.{md,mkd,markdown*} setfiletype markdown
autocmd! FT_MARKDOWN BufRead,BufNewFile TODO,README setfiletype markdown

" }}}

" {{{ [Nginx]

augroup FT_NGINX
  autocmd!
augroup END

autocmd! FT_NGINX BufRead,BufNewFile nginx.conf,nginx*.conf setfiletype nginx
autocmd! FT_NGINX BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

" }}}

" {{{ [Delimited Files]

augroup FT_DELIMITED
  autocmd!
augroup END

autocmd! FT_DELIMITED BufRead,BufNewFile *.csv,*.tsv setfiletype csv

" }}}

" {{{ [Postgres]

augroup FT_POSTGRES
  autocmd!
augroup END

autocmd! FT_POSTGRES BufRead,BufNewFile *.psql,*.pgsql,*.plpgsql setfiletype pgsql
autocmd! FT_POSTGRES BufRead,BufNewFile *.sql setfiletype pgsql
autocmd! FT_POSTGRES BufRead,BufNewFile .psqlrc setfiletype pgsql

" }}}

" {{{ [Zsh]

augroup FT_ZSH
  autocmd!
augroup END

autocmd! FT_ZSH BufRead,BufNewFile *zsh/functions* setfiletype zsh
autocmd! FT_ZSH BufRead,BufNewFile *zsh/*rc setfiletype zsh
autocmd! FT_ZSH BufRead,BufNewFile .zprofile setfiletype zsh
autocmd! FT_ZSH BufRead,BufNewFile .antigenrc setfiletype zsh
autocmd! FT_ZSH BufRead,BufNewFile *.zsh setfiletype zsh
autocmd! FT_ZSH BufRead,BufNewFile *.zsh setfiletype zsh

" }}}

" {{{ [JSON]

augroup FT_JSON
  autocmd!
augroup END

autocmd! FT_JSON BufRead,BufNewFile *.alfredappearance setfiletype json
autocmd! FT_JSON BufRead,BufNewFile .alex setfiletype json

" }}}

" {{{ [CLOJURE]

augroup FT_CLOJURE
  autocmd!
augroup END

autocmd! FT_CLOJURE BufRead,BufNewFile .joker setfiletype clojure

" }}}
