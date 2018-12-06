function! env#load() abort
  if empty($XDG_ROOT)
    if exists('g:gui_oni')
      let $XDG_ROOT = $HOME
    else
      throw 'Variable $XDG_ROOT is not set in ENV'
    endif
  endif

  if empty($XDG_CACHE_HOME)
    if exists('g:gui_vimr') || exists('g:gui_oni')
      let $XDG_CACHE_HOME = $XDG_ROOT . '/.cache'
    else
      throw 'Variable $XDG_CONFIG_HOME is not set in ENV'
    endif
  endif

  if empty($XDG_CONFIG_HOME)
    if exists('g:gui_vimr') || exists('g:gui_oni')
      let $XDG_CONFIG_HOME = $XDG_ROOT . '/.config'
    else
      throw 'Variable $XDG_CONFIG_HOME is not set in ENV'
    endif
  endif

  if empty($XDG_DATA_HOME)
    if exists('g:gui_vimr') || exists('g:gui_oni')
      let $XDG_DATA_HOME = $XDG_ROOT . '/.local/share'
    else
      throw 'Variable $XDG_DATA_HOME is not set in ENV'
    endif
  endif
endfunction
