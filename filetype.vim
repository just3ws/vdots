" {{{ [Ruby, Rake, and RSpec]

autocmd! BufRead,BufNewFile *.[cC]apfile,[cC]apfile,*.cap setfiletype ruby
autocmd! BufRead,BufNewFile *.builder,*.rxml,*.rjs,*.jbuilder,*.prawn setfiletype ruby
autocmd! BufRead,BufNewFile *.cr setfiletype ruby
autocmd! BufRead,BufNewFile *.gemspec setfiletype ruby
autocmd! BufRead,BufNewFile *.rb,*.rbw setfiletype ruby
autocmd! BufRead,BufNewFile *.ru setfiletype ruby
autocmd! BufRead,BufNewFile Berksfile,Berksfile.lock setfiletype ruby
autocmd! BufRead,BufNewFile COMMIT_EDITMSG setfiletype gitcommit
autocmd! BufRead,BufNewFile Gemfile setfiletype ruby
autocmd! BufRead,BufNewFile Guardfile setfiletype ruby
autocmd! BufRead,BufNewFile Puppetfile setfiletype ruby
autocmd! BufRead,BufNewFile Thorfile,Vagrantfile setfiletype ruby
autocmd! BufRead,BufNewFile [rR]antfile,*.rant setfiletype ruby
autocmd! BufRead,BufNewFile {.,}irbrc setfiletype ruby
autocmd! BufRead,BufNewFile {.,}pryrc setfiletype ruby

autocmd! BufRead,BufNewFile *.erb,*.rhtml setfiletype eruby

autocmd! BufRead,BufNewFile [rR]akefile,*.rake setfiletype rake

autocmd! BufRead,BufNewFile *_spec.rb set syntax=rspec

" }}}
"
" {{{ [Haml]

autocmd! BufRead,BufNewFile *.haml setfiletype haml

" }}}

" {{{ [Git]

autocmd! BufRead,BufNewFile MERGE_MSG setfiletype gitcommit
autocmd! BufRead,BufNewFile *.gitconfig setfiletype gitconfig

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
