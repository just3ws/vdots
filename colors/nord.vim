" Copyright (c) 2016-present Arctic Ice Studio <development@arcticicestudio.com>
" Copyright (c) 2016-present Sven Greb <code@svengreb.de>

" Project: Nord Vim
" Repository: https://github.com/arcticicestudio/nord-vim
" License: MIT

highlight! clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'nord'
let s:nord_vim_version='0.8.3'

set background=dark

let s:nord00_gui = '#2E3440'
let s:nord01_gui = '#3B4252' | let s:nord01_term = '0'
let s:nord02_gui = '#434C5E'
let s:nord03_gui = '#4C566A' | let s:nord03_term = '8'
let s:nord04_gui = '#D8DEE9'
let s:nord05_gui = '#E5E9F0' | let s:nord05_term = '7'
let s:nord06_gui = '#ECEFF4' | let s:nord06_term = '15'
let s:nord07_gui = '#8FBCBB' | let s:nord07_term = '14'
let s:nord08_gui = '#88C0D0' | let s:nord08_term = '6'
let s:nord09_gui = '#81A1C1' | let s:nord09_term = '4'
let s:nord10_gui = '#5E81AC' | let s:nord10_term = '12'
let s:nord11_gui = '#BF616A' | let s:nord11_term = '1'
let s:nord12_gui = '#D08770' | let s:nord12_term = '11'
let s:nord13_gui = '#EBCB8B' | let s:nord13_term = '3'
let s:nord14_gui = '#A3BE8C' | let s:nord14_term = '2'
let s:nord15_gui = '#B48EAD' | let s:nord15_term = '5'

let s:nord03_gui_brightened = [
  \ s:nord03_gui,
  \ '#4e586d',
  \ '#505b70',
  \ '#525d73',
  \ '#556076',
  \ '#576279',
  \ '#59647c',
  \ '#5b677f',
  \ '#5d6982',
  \ '#5f6c85',
  \ '#616e88',
  \ '#63718b',
  \ '#66738e',
  \ '#687591',
  \ '#6a7894',
  \ '#6d7a96',
  \ '#6f7d98',
  \ '#72809a',
  \ '#75829c',
  \ '#78859e',
  \ '#7b88a1',
\ ]

if !exists('g:nord_italic')
  if has('gui_running') || $TERM_ITALICS ==? 'true'
    let g:nord_italic=1
  else
    let g:nord_italic=0
  endif
endif

let s:italic = 'italic,'
if g:nord_italic == 0
  let s:italic = ''
endif

let s:italicize_comments = ''
if exists('g:nord_italic_comments')
  if g:nord_italic_comments == 1
    let s:italicize_comments = s:italic
  endif
endif

if !exists('g:nord_uniform_status_lines')
  let g:nord_uniform_status_lines = 0
endif

if !exists('g:nord_comment_brightness')
  let g:nord_comment_brightness = 0
endif

if !exists('g:nord_uniform_diff_background')
  let g:nord_uniform_diff_background = 0
endif

function! s:build_highlight(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  if a:guifg !=? ''
    exec 'highlight! ' . a:group . ' guifg=' . a:guifg
  endif

  if a:guibg !=? ''
    exec 'highlight! ' . a:group . ' guibg=' . a:guibg
  endif

  if a:ctermfg !=? ''
    exec 'highlight! ' . a:group . ' ctermfg=' . a:ctermfg
  endif

  if a:ctermbg !=? ''
    exec 'highlight! ' . a:group . ' ctermbg=' . a:ctermbg
  endif

  if a:attr !=? ''
    exec 'highlight! ' . a:group . ' gui=' . a:attr . ' cterm=' . a:attr
  endif

  if a:guisp !=? ''
    exec 'highlight! ' . a:group . ' guisp=' . a:guisp
  endif
endfunction

"+---------------+
"+ UI Components +
"+---------------+
"+--- Attributes ---+
call s:build_highlight('Bold', '', '', '', '', 'bold', '')
call s:build_highlight('Italic', '', '', '', '', s:italic, '')
call s:build_highlight('Underline', '', '', '', '', 'underline', '')

"+--- Editor ---+
call s:build_highlight('ColorColumn', '', s:nord01_gui, 'NONE', s:nord01_term, '', '')
call s:build_highlight('Cursor', s:nord00_gui, s:nord04_gui, '', 'NONE', '', '')
call s:build_highlight('CursorLine', '', s:nord01_gui, 'NONE', s:nord01_term, 'NONE', '')
call s:build_highlight('Error', s:nord00_gui, s:nord11_gui, '', s:nord11_term, '', '')
call s:build_highlight('iCursor', s:nord00_gui, s:nord04_gui, '', 'NONE', '', '')
call s:build_highlight('LineNr', s:nord03_gui, s:nord00_gui, s:nord03_term, 'NONE', '', '')
call s:build_highlight('MatchParen', s:nord08_gui, s:nord03_gui, s:nord08_term, s:nord03_term, '', '')
call s:build_highlight('NonText', s:nord02_gui, '', s:nord03_term, '', '', '')
call s:build_highlight('Normal', s:nord04_gui, s:nord00_gui, 'NONE', 'NONE', '', '')
call s:build_highlight('PMenu', s:nord04_gui, s:nord02_gui, 'NONE', s:nord01_term, 'NONE', '')
call s:build_highlight('PmenuSbar', s:nord04_gui, s:nord02_gui, 'NONE', s:nord01_term, '', '')
call s:build_highlight('PMenuSel', s:nord08_gui, s:nord03_gui, s:nord08_term, s:nord03_term, '', '')
call s:build_highlight('PmenuThumb', s:nord08_gui, s:nord03_gui, 'NONE', s:nord03_term, '', '')
call s:build_highlight('SpecialKey', s:nord03_gui, '', s:nord03_term, '', '', '')
call s:build_highlight('SpellBad', '', s:nord00_gui, '', 'NONE', 'undercurl', s:nord11_gui)
call s:build_highlight('SpellCap', '', s:nord00_gui, '', 'NONE', 'undercurl', s:nord13_gui)
call s:build_highlight('SpellLocal', '', s:nord00_gui, '', 'NONE', 'undercurl', s:nord05_gui)
call s:build_highlight('SpellRare', '', s:nord00_gui, '', 'NONE', 'undercurl', s:nord06_gui)
call s:build_highlight('Visual', '', s:nord02_gui, '', s:nord01_term, '', '')
call s:build_highlight('VisualNOS', '', s:nord02_gui, '', s:nord01_term, '', '')
"+- Neovim Support -+
call s:build_highlight('healthError', s:nord11_gui, s:nord01_gui, s:nord11_term, s:nord01_term, '', '')
call s:build_highlight('healthSuccess', s:nord14_gui, s:nord01_gui, s:nord14_term, s:nord01_term, '', '')
call s:build_highlight('healthWarning', s:nord13_gui, s:nord01_gui, s:nord13_term, s:nord01_term, '', '')
call s:build_highlight('TermCursorNC', '', s:nord01_gui, '', s:nord01_term, '', '')

"+- Neovim Terminal Colors -+
if has('nvim')
  let g:terminal_color_0 = s:nord01_gui
  let g:terminal_color_1 = s:nord11_gui
  let g:terminal_color_2 = s:nord14_gui
  let g:terminal_color_3 = s:nord13_gui
  let g:terminal_color_4 = s:nord09_gui
  let g:terminal_color_5 = s:nord15_gui
  let g:terminal_color_6 = s:nord08_gui
  let g:terminal_color_7 = s:nord05_gui
  let g:terminal_color_8 = s:nord03_gui
  let g:terminal_color_9 = s:nord11_gui
  let g:terminal_color_10 = s:nord14_gui
  let g:terminal_color_11 = s:nord13_gui
  let g:terminal_color_12 = s:nord09_gui
  let g:terminal_color_13 = s:nord15_gui
  let g:terminal_color_14 = s:nord07_gui
  let g:terminal_color_15 = s:nord06_gui
endif

"+--- Gutter ---+
call s:build_highlight('CursorColumn', '', s:nord01_gui, 'NONE', s:nord01_term, '', '')
call s:build_highlight('CursorLineNr', s:nord03_gui, s:nord00_gui, 'NONE', '', '', '')
call s:build_highlight('Folded', s:nord03_gui, s:nord01_gui, s:nord03_term, s:nord01_term, 'bold', '')
call s:build_highlight('FoldColumn', s:nord03_gui, s:nord00_gui, s:nord03_term, 'NONE', '', '')
call s:build_highlight('SignColumn', s:nord01_gui, s:nord00_gui, s:nord01_term, 'NONE', '', '')

"+--- Navigation ---+
call s:build_highlight('Directory', s:nord08_gui, '', s:nord08_term, 'NONE', '', '')

"+--- Prompt/Status ---+
call s:build_highlight('EndOfBuffer', s:nord01_gui, '', s:nord01_term, 'NONE', '', '')
call s:build_highlight('ErrorMsg', s:nord04_gui, s:nord11_gui, 'NONE', s:nord11_term, '', '')
call s:build_highlight('ModeMsg', s:nord04_gui, '', '', '', '', '')
call s:build_highlight('MoreMsg', s:nord04_gui, '', '', '', '', '')
call s:build_highlight('Question', s:nord04_gui, '', 'NONE', '', '', '')

if g:nord_uniform_status_lines == 0
  call s:build_highlight('StatusLine', s:nord08_gui, s:nord03_gui, s:nord08_term, s:nord03_term, 'NONE', '')
  call s:build_highlight('StatusLineNC', s:nord04_gui, s:nord01_gui, 'NONE', s:nord01_term, 'NONE', '')
  call s:build_highlight('StatusLineTerm', s:nord08_gui, s:nord03_gui, s:nord08_term, s:nord03_term, 'NONE', '')
  call s:build_highlight('StatusLineTermNC', s:nord04_gui, s:nord01_gui, 'NONE', s:nord01_term, 'NONE', '')
else
  call s:build_highlight('StatusLine', s:nord08_gui, s:nord03_gui, s:nord08_term, s:nord03_term, 'NONE', '')
  call s:build_highlight('StatusLineNC', s:nord04_gui, s:nord03_gui, 'NONE', s:nord03_term, 'NONE', '')
  call s:build_highlight('StatusLineTerm', s:nord08_gui, s:nord03_gui, s:nord08_term, s:nord03_term, 'NONE', '')
  call s:build_highlight('StatusLineTermNC', s:nord04_gui, s:nord03_gui, 'NONE', s:nord03_term, 'NONE', '')
endif

call s:build_highlight('WarningMsg', s:nord00_gui, s:nord13_gui, s:nord01_term, s:nord13_term, '', '')
call s:build_highlight('WildMenu', s:nord08_gui, s:nord01_gui, s:nord08_term, s:nord01_term, '', '')

"+--- Search ---+
call s:build_highlight('IncSearch', s:nord01_gui, s:nord08_gui, s:nord01_term, s:nord08_term, 'underline', '')
call s:build_highlight('Search', s:nord01_gui, s:nord08_gui, s:nord01_term, s:nord08_term, 'NONE', '')

"+--- Tabs ---+
call s:build_highlight('TabLine', s:nord04_gui, s:nord01_gui, 'NONE', s:nord01_term, 'NONE', '')
call s:build_highlight('TabLineFill', s:nord04_gui, s:nord01_gui, 'NONE', s:nord01_term, 'NONE', '')
call s:build_highlight('TabLineSel', s:nord08_gui, s:nord03_gui, s:nord08_term, s:nord03_term, 'NONE', '')

"+--- Window ---+
call s:build_highlight('Title', s:nord04_gui, '', 'NONE', '', 'NONE', '')
call s:build_highlight('VertSplit', s:nord02_gui, s:nord01_gui, s:nord03_term, s:nord01_term, 'NONE', '')

"+----------------------+
"+ Language Base Groups +
"+----------------------+
call s:build_highlight('Boolean', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Character', s:nord14_gui, '', s:nord14_term, '', '', '')
call s:build_highlight('Comment', s:nord03_gui_brightened[g:nord_comment_brightness], '', s:nord03_term, '', s:italicize_comments, '')
call s:build_highlight('Conditional', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Constant', s:nord04_gui, '', 'NONE', '', '', '')
call s:build_highlight('Define', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Delimiter', s:nord06_gui, '', s:nord06_term, '', '', '')
call s:build_highlight('Exception', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Float', s:nord15_gui, '', s:nord15_term, '', '', '')
call s:build_highlight('Function', s:nord08_gui, '', s:nord08_term, '', '', '')
call s:build_highlight('Identifier', s:nord04_gui, '', 'NONE', '', 'NONE', '')
call s:build_highlight('Include', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Keyword', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Label', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Number', s:nord15_gui, '', s:nord15_term, '', '', '')
call s:build_highlight('Operator', s:nord09_gui, '', s:nord09_term, '', 'NONE', '')
call s:build_highlight('PreProc', s:nord09_gui, '', s:nord09_term, '', 'NONE', '')
call s:build_highlight('Repeat', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Special', s:nord04_gui, '', 'NONE', '', '', '')
call s:build_highlight('SpecialChar', s:nord13_gui, '', s:nord13_term, '', '', '')
call s:build_highlight('SpecialComment', s:nord08_gui, '', s:nord08_term, '', s:italicize_comments, '')
call s:build_highlight('Statement', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('StorageClass', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('String', s:nord14_gui, '', s:nord14_term, '', '', '')
call s:build_highlight('Structure', s:nord09_gui, '', s:nord09_term, '', '', '')
call s:build_highlight('Tag', s:nord04_gui, '', '', '', '', '')
call s:build_highlight('Todo', s:nord13_gui, 'NONE', s:nord13_term, 'NONE', '', '')
call s:build_highlight('Type', s:nord09_gui, '', s:nord09_term, '', 'NONE', '')
call s:build_highlight('Typedef', s:nord09_gui, '', s:nord09_term, '', '', '')

highlight! link Macro Define
highlight! link PreCondit PreProc

"+-----------+
"+ Languages +
"+-----------+
call s:build_highlight('awkCharClass', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('awkPatterns', s:nord09_gui, '', s:nord09_term, '', 'bold', '')

highlight! link awkArrayElement Identifier
highlight! link awkBoolLogic Keyword
highlight! link awkBrktRegExp SpecialChar
highlight! link awkComma Delimiter
highlight! link awkExpression Keyword
highlight! link awkFieldVars Identifier
highlight! link awkLineSkip Keyword
highlight! link awkOperator Operator
highlight! link awkRegExp SpecialChar
highlight! link awkSearch Keyword
highlight! link awkSemicolon Delimiter
highlight! link awkSpecialCharacter SpecialChar
highlight! link awkSpecialPrintf SpecialChar
highlight! link awkVariables Identifier

call s:build_highlight('cIncluded', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link cOperator Operator
highlight! link cPreCondit PreCondit

highlight! link csPreCondit PreCondit
highlight! link csType Type
highlight! link csXmlTag SpecialComment

call s:build_highlight('cssAttributeSelector', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('cssDefinition', s:nord07_gui, '', s:nord07_term, '', 'NONE', '')
call s:build_highlight('cssIdentifier', s:nord07_gui, '', s:nord07_term, '', 'underline', '')
call s:build_highlight('cssStringQ', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link cssAttr Keyword
highlight! link cssBraces Delimiter
highlight! link cssClassName cssDefinition
highlight! link cssColor Number
highlight! link cssProp cssDefinition
highlight! link cssPseudoClass cssDefinition
highlight! link cssPseudoClassId cssPseudoClass
highlight! link cssVendor Keyword

call s:build_highlight('dosiniHeader', s:nord08_gui, '', s:nord08_term, '', '', '')

highlight! link dosiniLabel Type

call s:build_highlight('dtBooleanKey', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('dtExecKey', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('dtLocaleKey', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('dtNumericKey', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('dtTypeKey', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link dtDelim Delimiter
highlight! link dtLocaleValue Keyword
highlight! link dtTypeValue Keyword

if g:nord_uniform_diff_background == 0
  call s:build_highlight('DiffAdd', s:nord14_gui, s:nord00_gui, s:nord14_term, 'NONE', 'inverse', '')
  call s:build_highlight('DiffChange', s:nord13_gui, s:nord00_gui, s:nord13_term, 'NONE', 'inverse', '')
  call s:build_highlight('DiffDelete', s:nord11_gui, s:nord00_gui, s:nord11_term, 'NONE', 'inverse', '')
  call s:build_highlight('DiffText', s:nord13_gui, s:nord00_gui, s:nord13_term, 'NONE', 'inverse', '')
else
  call s:build_highlight('DiffAdd', s:nord14_gui, s:nord01_gui, s:nord14_term, s:nord01_term, '', '')
  call s:build_highlight('DiffChange', s:nord13_gui, s:nord01_gui, s:nord13_term, s:nord01_term, '', '')
  call s:build_highlight('DiffDelete', s:nord11_gui, s:nord01_gui, s:nord11_term, s:nord01_term, '', '')
  call s:build_highlight('DiffText', s:nord13_gui, s:nord01_gui, s:nord13_term, s:nord01_term, '', '')
endif

" Legacy groups for official git.vim and diff.vim syntax
highlight! link diffAdded DiffAdd
highlight! link diffChanged DiffChange
highlight! link diffRemoved DiffDelete

call s:build_highlight('gitconfigVariable', s:nord07_gui, '', s:nord07_term, '', '', '')

call s:build_highlight('goBuiltins', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link goConstants Keyword

call s:build_highlight('helpBar', s:nord03_gui, '', s:nord03_term, '', '', '')
call s:build_highlight('helpHyperTextJump', s:nord08_gui, '', s:nord08_term, '', 'underline', '')

call s:build_highlight('htmlArg', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('htmlLink', s:nord04_gui, '', '', '', 'NONE', 'NONE')

highlight! link htmlBold Bold
highlight! link htmlEndTag htmlTag
highlight! link htmlItalic Italic
highlight! link htmlH1 markdownH1
highlight! link htmlH2 markdownH1
highlight! link htmlH3 markdownH1
highlight! link htmlH4 markdownH1
highlight! link htmlH5 markdownH1
highlight! link htmlH6 markdownH1
highlight! link htmlSpecialChar SpecialChar
highlight! link htmlTag Keyword
highlight! link htmlTagN htmlTag

call s:build_highlight('javaDocTags', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link javaCommentTitle Comment
highlight! link javaScriptBraces Delimiter
highlight! link javaScriptIdentifier Keyword
highlight! link javaScriptNumber Number

call s:build_highlight('jsonKeyword', s:nord07_gui, '', s:nord07_term, '', '', '')

call s:build_highlight('lessClass', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link lessAmpersand Keyword
highlight! link lessCssAttribute Delimiter
highlight! link lessFunction Function
highlight! link cssSelectorOp Keyword

highlight! link lispAtomBarSymbol SpecialChar
highlight! link lispAtomList SpecialChar
highlight! link lispAtomMark Keyword
highlight! link lispBarSymbol SpecialChar
highlight! link lispFunc Function

highlight! link luaFunc Function

call s:build_highlight('markdownBlockquote', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('markdownCode', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('markdownCodeDelimiter', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('markdownFootnote', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('markdownId', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('markdownIdDeclaration', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('markdownH1', s:nord08_gui, '', s:nord08_term, '', '', '')
call s:build_highlight('markdownLinkText', s:nord08_gui, '', s:nord08_term, '', '', '')
call s:build_highlight('markdownUrl', s:nord04_gui, '', 'NONE', '', 'NONE', '')

highlight! link markdownBold Bold
highlight! link markdownBoldDelimiter Keyword
highlight! link markdownFootnoteDefinition markdownFootnote
highlight! link markdownH2 markdownH1
highlight! link markdownH3 markdownH1
highlight! link markdownH4 markdownH1
highlight! link markdownH5 markdownH1
highlight! link markdownH6 markdownH1
highlight! link markdownIdDelimiter Keyword
highlight! link markdownItalic Italic
highlight! link markdownItalicDelimiter Keyword
highlight! link markdownLinkDelimiter Keyword
highlight! link markdownLinkTextDelimiter Keyword
highlight! link markdownListMarker Keyword
highlight! link markdownRule Keyword
highlight! link markdownHeadingDelimiter Keyword

call s:build_highlight('perlPackageDecl', s:nord07_gui, '', s:nord07_term, '', '', '')

call s:build_highlight('phpClasses', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('phpDocTags', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link phpDocCustomTags phpDocTags
highlight! link phpMemberSelector Keyword

call s:build_highlight('podCmdText', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('podVerbatimLine', s:nord04_gui, '', 'NONE', '', '', '')
highlight! link podFormat Keyword

highlight! link pythonBuiltin Type
highlight! link pythonEscape SpecialChar

call s:build_highlight('rubyConstant', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('rubySymbol', s:nord06_gui, '', s:nord06_term, '', 'bold', '')

highlight! link rubyAttribute Identifier
highlight! link rubyBlockParameterList Operator
highlight! link rubyInterpolationDelimiter Keyword
highlight! link rubyKeywordAsMethod Function
highlight! link rubyLocalVariableOrMethod Function
highlight! link rubyPseudoVariable Keyword
highlight! link rubyRegexp SpecialChar

call s:build_highlight('sassClass', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('sassId', s:nord07_gui, '', s:nord07_term, '', 'underline', '')

highlight! link sassAmpersand Keyword
highlight! link sassClassChar Delimiter
highlight! link sassControl Keyword
highlight! link sassControlLine Keyword
highlight! link sassExtend Keyword
highlight! link sassFor Keyword
highlight! link sassFunctionDecl Keyword
highlight! link sassFunctionName Function
highlight! link sassidChar sassId
highlight! link sassInclude SpecialChar
highlight! link sassMixinName Function
highlight! link sassMixing SpecialChar
highlight! link sassReturn Keyword

highlight! link shCmdParenRegion Delimiter
highlight! link shCmdSubRegion Delimiter
highlight! link shDerefSimple Identifier
highlight! link shDerefVar Identifier

highlight! link sqlKeyword Keyword
highlight! link sqlSpecial Keyword

call s:build_highlight('vimAugroup', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('vimMapRhs', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('vimNotation', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link vimFunc Function
highlight! link vimFunction Function
highlight! link vimUserFunc Function

call s:build_highlight('xmlAttrib', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('xmlCdataStart', s:nord03_gui, '', s:nord03_term, '', 'bold', '')
call s:build_highlight('xmlNamespace', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link xmlAttribPunct Delimiter
highlight! link xmlCdata Comment
highlight! link xmlCdataCdata xmlCdataStart
highlight! link xmlCdataEnd xmlCdataStart
highlight! link xmlEndTag xmlTagName
highlight! link xmlProcessingDelim Keyword
highlight! link xmlTagName Keyword

call s:build_highlight('yamlBlockMappingKey', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link yamlBool Keyword
highlight! link yamlDocumentStart Keyword

"+----------------+
"+ Plugin Support +
"+----------------+
"+--- UI ---+
" ALE
" > w0rp/ale
call s:build_highlight('ALEWarningSign', s:nord13_gui, '', s:nord13_term, '', '', '')
call s:build_highlight('ALEErrorSign' , s:nord11_gui, '', s:nord11_term, '', '', '')

" fugitive.vim
" > tpope/vim-fugitive
call s:build_highlight('gitcommitDiscardedFile', s:nord11_gui, '', s:nord11_term, '', '', '')
call s:build_highlight('gitcommitUntrackedFile', s:nord11_gui, '', s:nord11_term, '', '', '')
call s:build_highlight('gitcommitSelectedFile', s:nord14_gui, '', s:nord14_term, '', '', '')

" davidhalter/jedi-vim
call s:build_highlight('jediFunction', s:nord04_gui, s:nord03_gui, '', s:nord03_term, '', '')
call s:build_highlight('jediFat', s:nord08_gui, s:nord03_gui, s:nord08_term, s:nord03_term, 'bold,underline', '')

" NERDTree
" > scrooloose/nerdtree
call s:build_highlight('NERDTreeExecFile', s:nord07_gui, '', s:nord07_term, '', '', '')

highlight! link NERDTreeDirSlash Keyword
highlight! link NERDTreeHelp Comment

"+--- Languages ---+
" JavaScript
" > pangloss/vim-javascript
call s:build_highlight('jsGlobalNodeObjects', s:nord08_gui, '', s:nord08_term, '', s:italic, '')

highlight! link jsBrackets Delimiter
highlight! link jsFuncCall Function
highlight! link jsFuncParens Delimiter
highlight! link jsNoise Delimiter
highlight! link jsPrototype Keyword
highlight! link jsRegexpString SpecialChar

" Markdown
" > plasticboy/vim-markdown
call s:build_highlight('mkdCode', s:nord07_gui, '', s:nord07_term, '', '', '')
call s:build_highlight('mkdFootnote', s:nord08_gui, '', s:nord08_term, '', '', '')
call s:build_highlight('mkdRule', s:nord10_gui, '', s:nord10_term, '', '', '')
call s:build_highlight('mkdLineBreak', s:nord09_gui, '', s:nord09_term, '', '', '')

highlight! link mkdBold Bold
highlight! link mkdItalic Italic
highlight! link mkdString Keyword
highlight! link mkdCodeStart mkdCode
highlight! link mkdCodeEnd mkdCode
highlight! link mkdBlockquote Comment
highlight! link mkdListItem Keyword
highlight! link mkdListItemLine Normal
highlight! link mkdFootnotes mkdFootnote
highlight! link mkdLink markdownLinkText
highlight! link mkdURL markdownUrl
highlight! link mkdInlineURL mkdURL
highlight! link mkdID Identifier
highlight! link mkdLinkDef mkdLink
highlight! link mkdLinkDefTarget mkdURL
highlight! link mkdLinkTitle mkdInlineURL
highlight! link mkdDelimiter Keyword
