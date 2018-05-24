augroup ftdetect
  autocmd!
augroup end

" {{{ [Ruby, Rake, and RSpec]

autocmd! ftdetect BufRead,BufNewFile [rR]akefile,*.rake setfiletype ruby.rake

autocmd! ftdetect BufNewFile,BufRead Gemfile,Gemfile.lock setfiletype ruby.rails.bundler
autocmd! ftdetect BufEnter Gemfile,Gemfile.lock setfiletype ruby.rails.bundler

autocmd! ftdetect BufRead,BufNewFile *_spec.rb setfiletype ruby.rspec

autocmd! ftdetect BufNewFile,BufRead *.{erb,rhtml,ecr,mobile*} setfiletype eruby
autocmd! ftdetect BufEnter,BufNewFile *.{arb,builder,cap,gem,gemspec,god,jbuilder,opal,podspec,rabl,rb,rb2,rbw,rjs,ru,ruby,rxml,step,thor} setfiletype ruby
autocmd! ftdetect BufEnter,BufNewFile .{autotest,simplecov} setfiletype ruby
autocmd! ftdetect BufEnter,BufNewFile {.,}guardrc,{.,}pryrc,{.,}irbrc  setfiletype ruby
autocmd! ftdetect BufEnter,BufNewFile {[cC]apfile,[tT]horfile} setfiletype ruby
autocmd! ftdetect BufEnter,BufNewFile {Appraisals,Berksfile,Brewfile,Buildfile,Cheffile,Guardfile,KitchenSink,Podfile,Puppetfile,Thorfile,Vagrantfile} setfiletype ruby

" }}}

" {{{ [Git]

autocmd! ftdetect BufRead,BufNewFile MERGE_MSG setfiletype gitcommit
autocmd! ftdetect BufRead,BufNewFile *.gitconfig setfiletype gitconfig
autocmd! ftdetect BufRead,BufNewFile COMMIT_EDITMSG setfiletype gitcommit

" }}}

" {{{ [HOSTS]

autocmd! ftdetect BufRead,BufNewFile */etc/host.conf setfiletype hostconf
autocmd! ftdetect BufRead,BufNewFile /private/etc/hosts,/etc/hosts setfiletype hostaccess

" }}}

" {{{ [tmux]

autocmd! ftdetect BufRead,BufNewFile {.,}tmux*.conf* setfiletype tmux

" }}}

" {{{ [Markdown]

autocmd! ftdetect BufRead,BufNewFile *.{md,mkd,markdown*} setfiletype markdown
autocmd! ftdetect BufRead,BufNewFile TODO,README setfiletype markdown

" }}}

" {{{ [Nginx]

autocmd! ftdetect BufRead,BufNewFile nginx.conf,nginx*.conf setfiletype nginx
autocmd! ftdetect BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

" }}}

" {{{ [Delimited Files]

autocmd! ftdetect BufRead,BufNewFile *.csv,*.tsv setfiletype csv

" }}}

" {{{ [Postgres]

autocmd! ftdetect BufRead,BufNewFile *.psql,*.pgsql,*.plpgsql setfiletype pgsql
autocmd! ftdetect BufRead,BufNewFile *.sql setfiletype pgsql
autocmd! ftdetect BufRead,BufNewFile .psqlrc setfiletype pgsql

" }}}

" {{{ [Zsh]

autocmd! ftdetect BufRead,BufNewFile *zsh/functions* setfiletype zsh
autocmd! ftdetect BufRead,BufNewFile *zsh/*rc setfiletype zsh
autocmd! ftdetect BufRead,BufNewFile .zprofile setfiletype zsh
autocmd! ftdetect BufRead,BufNewFile .antigenrc setfiletype zsh
autocmd! ftdetect BufRead,BufNewFile *.zsh setfiletype zsh
autocmd! ftdetect BufRead,BufNewFile *.zsh setfiletype zsh

" }}}

" {{{ [JSON]

autocmd! ftdetect BufRead,BufNewFile *.alfredappearance setfiletype json
autocmd! ftdetect BufRead,BufNewFile .alex setfiletype json
autocmd! ftdetect BufRead,BufNewFile .firebaserc setfiletype json

" }}}

" {{{ [CLOJURE]

autocmd! ftdetect BufRead,BufNewFile .joker setfiletype clojure

" }}}
