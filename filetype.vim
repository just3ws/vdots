augroup filetypedetect
  au BufRead,BufNewFile README,*.md set filetype=markdown
  au BufRead,BufNewFile .mdlrc set filetype=ruby
  au BufRead,BufNewFile .env,.env.* set filetype=shell
  au BufRead,BufNewFile .{jscs,jshint,eslint,prettier}rc set filetype=json
  au BufRead,BufNewFile *.lst set filetype=text
  au BufRead,BufNewFile * match BadWhitespace /\s\+$/
augroup END
