" setfiletype will not overwrite the filetype if already set

augroup filetypedetect
  " autocmd BufNewFile,BufRead [rR]akefile,*.rake setfiletype ruby.rake
  " autocmd BufNewFile,BufRead Gemfile,Gemfile.lock setfiletype ruby.rails.bundler
  " autocmd BufEnter Gemfile,Gemfile.lock setfiletype ruby.rails.bundler
  " autocmd BufNewFile,BufRead *_spec.rb setfiletype ruby.rspec
  " autocmd BufNewFile,BufRead *.{erb,rhtml,ecr,mobile*} setfiletype eruby
  " autocmd BufEnter,BufNewFile *.{arb,builder,cap,gem,gemspec,god,jbuilder,opal,podspec,rabl,rb,rb2,rbw,rjs,ru,ruby,rxml,step,thor} setfiletype ruby
  " autocmd BufEnter,BufNewFile .{autotest,simplecov} setfiletype ruby
  " autocmd BufEnter,BufNewFile {.,}guardrc,{.,}pryrc,{.,}irbrc  setfiletype ruby
  " autocmd BufEnter,BufNewFile {[cC]apfile,[tT]horfile} setfiletype ruby
  " autocmd BufEnter,BufNewFile {Appraisals,Berksfile,Brewfile,Buildfile,Cheffile,Guardfile,KitchenSink,Podfile,Puppetfile,Thorfile,Vagrantfile} setfiletype ruby
  " autocmd BufNewFile,BufRead MERGE_MSG setfiletype gitcommit
  " autocmd BufNewFile,BufRead *.gitconfig setfiletype gitconfig
  " autocmd BufNewFile,BufRead COMMIT_EDITMSG setfiletype gitcommit
  " autocmd BufNewFile,BufRead */etc/host.conf setfiletype hostconf
  " autocmd BufNewFile,BufRead /private/etc/hosts,/etc/hosts setfiletype hostaccess
  " autocmd BufNewFile,BufRead {.,}tmux*.conf* setfiletype tmux
  " autocmd BufNewFile,BufRead *.{md,mkd,markdown*} setfiletype markdown
  " autocmd BufNewFile,BufRead TODO,README setfiletype markdown
  " autocmd BufNewFile,BufRead nginx.conf,nginx*.conf setfiletype nginx
  " autocmd BufNewFile,BufRead /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif
  " autocmd BufNewFile,BufRead *.csv,*.tsv,*.dat setfiletype csv
  " autocmd BufNewFile,BufRead *.psql,*.pgsql,*.plpgsql setfiletype pgsql
  " autocmd BufNewFile,BufRead *.sql setfiletype pgsql
  " autocmd BufNewFile,BufRead .psqlrc setfiletype pgsql
  " autocmd BufNewFile,BufRead *zsh/functions* setfiletype zsh
  " autocmd BufNewFile,BufRead *zsh/*rc setfiletype zsh
  " autocmd BufNewFile,BufRead .zprofile setfiletype zsh
  " autocmd BufNewFile,BufRead .antigenrc setfiletype zsh
  " autocmd BufNewFile,BufRead *.zsh setfiletype zsh
  " autocmd BufNewFile,BufRead *.alfredappearance,.alex,.firebaserc,.babelrc,.prettierrc,.eslintrc,.stylelintrc setfiletype json
  " autocmd BufNewFile,BufRead .joker setfiletype clojure

  " autocmd BufNewFile,BufRead */Hosted/admin/templates/**.htm set filetype=smarty
  " autocmd BufNewFile,BufRead */Hosted/admin/templates/**.txt set filetype=smarty
  " autocmd BufNewFile,BufRead */Hosted/templates/**.htm set filetype=smarty
  " autocmd BufNewFile,BufRead */Hosted/templates/**.txt set filetype=smarty

  autocmd BufNewFile,BufRead *.lst set filetype=text
augroup END
