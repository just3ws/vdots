let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 1
let g:startify_custom_header = []
let g:startify_enable_unsafe = 1
let g:startify_files_number = 20
let g:startify_fortune_use_unicode = 0
let g:startify_padding_left = 4
let g:startify_recursive_dir = 1
let g:startify_relative_path = 1
let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
" let g:startify_session_dir = $STARTIFY_SESSION_DIR
let g:startify_session_persistence = 1
let g:startify_session_sort = 1
let g:startify_show_files = 1
let g:startify_show_sessions = 1
let g:startify_update_oldfiles = 1
let g:startify_use_env = 1

let g:startify_list_order = [
      \ [' === Last modified files in: ' . getcwd() ], 'dir',
      \ [' === Recent files:'], 'files',
      \ [' === Bookmarks:'], 'bookmarks',
      \ [' === Commands:'], 'commands',
      \ [' === Sessions:'], 'sessions'
      \ ]

let g:startify_skiplist = [
      \ $HOME . '/private/*',
      \ $VIMRUNTIME . '/doc',
      \ '/Desktop',
      \ '/tmp',
      \ 'COMMIT_EDITMSG',
      \ '\.\(jpg\|png\|jpeg\|txt\)',
      \ '\.git',
      \ '\.log$',
      \ '\init.vim$',
      \ 'bundle/.*/doc',
      \ 'vimpager',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\').'doc'
      \ ]

let g:startify_bookmarks = [
      \  { 'z': '~/.config/zsh/.zshrc'            },
      \  { 'Z': '~/.zshenv'                       },
      \  { 't': '~/.config/tmux/tmux.conf'        },
      \  { 'v': $MYVIMRC                          }
      \ ]

let g:startify_commands = [
      \ {'p': 'call dein#update()'},
      \ ]

function! ToStartify() abort
  if winnr('$') == 1 && buffer_name(winbufnr(winnr())) !=? ''
    vsplit
    Startify
    exec 'normal \<c-w>w'
  endif
endfunction

" autocmd! ft_startify User Startified setlocal buftype= cursorline nofoldenable nolist
" autocmd! ft_startify QuitPre * call ToStartify()
