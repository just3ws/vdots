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
"
" {{{ [Haml]

autocmd! BufRead,BufNewFile *.haml setfiletype haml

" }}}

" {{{ [Git]

autocmd! BufRead,BufNewFile MERGE_MSG setfiletype gitcommit
autocmd! BufRead,BufNewFile *.gitconfig setfiletype gitconfig
autocmd! BufRead,BufNewFile COMMIT_EDITMSG setfiletype gitcommit

" }}}

" {{{ [AppleScript]

autocmd! BufRead,BufNewFile *.scpt,*.scptd,*.applescript, setfiletype applescript

" }}}

" {{{ [HOSTS]

autocmd! BufRead,BufNewFile */etc/host.conf setfiletype hostconf
autocmd! BufRead,BufNewFile /private/etc/hosts,/etc/hosts setfiletype hostaccess

" }}}

" {{{ [tmux]

autocmd! BufRead,BufNewFile {.,}tmux*.conf* setfiletype tmux

" }}}

" {{{ [Markdown]

autocmd! BufRead,BufNewFile *.{md,mkd,markdown*} setfiletype markdown
autocmd! BufRead,BufNewFile TODO,README setfiletype markdown

" }}}

" {{{ [Nginx]

autocmd! BufRead,BufNewFile nginx.conf,nginx*.conf setfiletype nginx
autocmd! BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

" }}}

" {{{ [Delimited Files]

autocmd! BufRead,BufNewFile *.csv,*.tsv setfiletype csv

" }}}

" {{{ [CoffeeScript]

autocmd! BufRead,BufNewFile *.coffee setfiletype coffee

" }}}

" {{{ [Postgres]

autocmd! BufRead,BufNewFile *.psql,*.pgsql,*.plpgsql setfiletype pgsql
autocmd! BufRead,BufNewFile *.sql setfiletype pgsql
autocmd! BufRead,BufNewFile .psqlrc setfiletype pgsql

" }}}

" {{{ [Zsh]

autocmd! BufRead,BufNewFile *zsh/functions* setfiletype zsh
autocmd! BufRead,BufNewFile *zsh/*rc setfiletype zsh
autocmd! BufRead,BufNewFile .zprofile setfiletype zsh
autocmd! BufRead,BufNewFile .antigenrc setfiletype zsh
autocmd! BufRead,BufNewFile *.zsh setfiletype zsh
autocmd! BufRead,BufNewFile *.zsh setfiletype zsh

" }}}

autocmd! BufRead,BufNewFile *.alfredappearance setfiletype json
