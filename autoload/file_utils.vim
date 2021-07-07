function! file_utils#init_app_dir(path) abort
  let l:directory = stdpath('data') . a:path

  call mkdir(l:directory, 'p')

  return l:directory
endfunction
