" === BACKUP SETTINGS ===
" Turn backup OFF
" Normally we would want to have it turned on. See bug and workaround below.
" OBS: It's a known-bug that backupdir is not supporting
" the correct double slash filename expansion
" see: https://code.google.com/p/vim/issues/detail?id=179
set nobackup

" set a centralized backup directory
" set backupdir=~/.vim/backup//
" set writebackup " Make a backup of the original file when writing
" set backup
set backupskip+=*.log " Don't backup log files

" This is the workaround for the backup filename expansion problem.
autocmd! vimrc BufWritePre * call backup#save_backups()

function! backup#save_backups() abort
  if expand('%:p') =~ &backupskip | return | endif

  " If this is a newly created file, don't try to create a backup
  if !filereadable(@%) | return | endif

  for l:backupdir in split(&backupdir, ',')
    call backup#save_backup(l:backupdir)
  endfor
endfunction

function! backup#save_backup(backupdir) abort
  let l:filename = expand('%:p')
  if a:backupdir =~? '//$'
    let l:backup = escape(substitute(l:filename, '/', '%', 'g')  . &backupext, '%')
  else
    let l:backup = escape(expand('%') . &backupext, '%')
  endif

  let l:backup_path = a:backupdir . l:backup

  :silent! execute '!cp ' . resolve(l:filename) . ' ' . l:backup_path
endfunction
