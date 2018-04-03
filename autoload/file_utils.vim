function! file_utils#mkdir_p(directory)
  if isdirectory(a:directory) | else
    call mkdir(a:directory, 'p')
  endif
endfunction

function! file_utils#vim_dir()
  if has('nvim') | return '/nvim' | endif

  return '/vim'
endfunction

function! file_utils#init_app_dir(path)

  let l:directory = expand($XDG_DATA_HOME . file_utils#vim_dir()) . a:path

  call file_utils#mkdir_p(l:directory)

  return l:directory
endfunction

function file_utils#init_app_dirs(directories)
endfunction
