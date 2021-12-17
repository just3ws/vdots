augroup filetypedetect
  au BufRead,BufNewFile * match BadWhitespace /\s\+$/
  au BufRead,BufNewFile *.lst set filetype=text
  au BufRead,BufNewFile .env,.env.* set filetype=shell
  au BufRead,BufNewFile .mdlrc set filetype=ruby
  au BufRead,BufNewFile .{jscs,jshint,eslint,prettier}rc set filetype=json
  au BufRead,BufNewFile README,*.md set filetype=markdown
augroup END
