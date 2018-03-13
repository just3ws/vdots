" {{{ [Ruby, Rake, and RSpec]

autocmd! Vimrc BufRead,BufNewFile *.[cC]apfile,[cC]apfile,*.cap setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.builder,*.rxml,*.rjs,*.jbuilder,*.prawn setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.cr setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.gemspec setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.rb,*.rbw setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile *.ru setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile Berksfile,Berksfile.lock setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile COMMIT_EDITMSG setfiletype gitcommit
autocmd! Vimrc BufRead,BufNewFile Gemfile setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile Guardfile setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile Puppetfile setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile Thorfile,Vagrantfile setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile [rR]antfile,*.rant setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile {.,}irbrc setfiletype ruby
autocmd! Vimrc BufRead,BufNewFile {.,}pryrc setfiletype ruby

autocmd! Vimrc BufRead,BufNewFile *.erb,*.rhtml setfiletype eruby

autocmd! Vimrc BufRead,BufNewFile [rR]akefile,*.rake setfiletype rake

autocmd! Vimrc BufRead,BufNewFile *_spec.rb set syntax=rspec

" }}}
"
" {{{ [Haml]

autocmd! Vimrc BufRead,BufNewFile *.haml setfiletype haml

" }}}

" {{{ [Git]

autocmd! Vimrc BufRead,BufNewFile MERGE_MSG setfiletype gitcommit
autocmd! Vimrc BufRead,BufNewFile *.gitconfig setfiletype gitconfig

" }}}

" {{{ [AppleScript]

autocmd! Vimrc BufRead,BufNewFile *.scpt,*.scptd,*.applescript, setfiletype applescript

" }}}

" {{{ [HOSTS]

autocmd! Vimrc BufRead,BufNewFile */etc/host.conf setfiletype hostconf
autocmd! Vimrc BufRead,BufNewFile /private/etc/hosts,/etc/hosts setfiletype hostaccess

" }}}

" {{{ [tmux]

autocmd! Vimrc BufRead,BufNewFile {.,}tmux*.conf* setfiletype tmux

" }}}

" {{{ [Markdown]

autocmd! Vimrc BufRead,BufNewFile *.{md,mkd,markdown*} setfiletype markdown
autocmd! Vimrc BufRead,BufNewFile TODO,README setfiletype markdown

" }}}

" {{{ [Nginx]

autocmd! Vimrc BufRead,BufNewFile nginx.conf,nginx*.conf setfiletype nginx
autocmd! Vimrc BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

" }}}

" {{{ [Delimited Files]

autocmd! Vimrc BufRead,BufNewFile *.csv,*.tsv setfiletype csv

" }}}

" {{{ [CoffeeScript]

autocmd! Vimrc BufRead,BufNewFile *.coffee setfiletype coffee

" }}}

" {{{ [Postgres]

autocmd! Vimrc BufRead,BufNewFile *.psql,*.pgsql,*.plpgsql setfiletype pgsql
autocmd! Vimrc BufRead,BufNewFile *.sql setfiletype pgsql
autocmd! Vimrc BufRead,BufNewFile .psqlrc setfiletype pgsql

" }}}

" {{{ [Zsh]

autocmd! Vimrc BufRead,BufNewFile *zsh/functions* setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile *zsh/*rc setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile .zprofile setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile .antigenrc setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile *.zsh setfiletype zsh
autocmd! Vimrc BufRead,BufNewFile *.zsh setfiletype zsh

" }}}
