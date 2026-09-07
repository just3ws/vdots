" Vim syntax file
" Language: ack configuration file (.ackrc)
" Maintainer: vdots

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Comments
syn match ackrcComment "^\s*#.*$" contains=ackrcTodo,@Spell
syn match ackrcComment "\s\+#.*$" contains=ackrcTodo,@Spell
syn keyword ackrcTodo contained TODO FIXME XXX NOTE BUG

" Delimiters & Operators
syn match ackrcDelimiter "[=:]"
syn match ackrcComma ","

" Strings
syn region ackrcString start=+"+ end=+"+ skip=+\\"+ contains=ackrcEscape,@ackrcColors
syn region ackrcString start=+'+ end=+'+ skip=+\\'+ contains=ackrcEscape,@ackrcColors
syn match ackrcEscape contained "\\[\\'"trn]"

" Numbers
syn match ackrcNumber "\<\d\+\>"

" Regular expressions (e.g. match:/\.DS_Store$/ or /tags$/)
syn region ackrcRegex start=+/[^/]+ end=+/[iI]*+ skip=+\\/+ contains=ackrcRegexEscape
syn match ackrcRegexEscape contained "\\[/\\.^$*+?()[\]{}|]"

" Extensions (e.g. .js, .lua, .min.css)
syn match ackrcExtension "\.[a-zA-Z0-9_+*-]\+"

" Filter types (ext:, is:, match:, firstlinematch:)
syn match ackrcFilterType "\<\(ext\|is\|match\|firstlinematch\)\ze:"

" Fallback general flags / options (defined first so specific directives win)
syn match ackrcFlag "--[a-zA-Z0-9_-]\+"
syn match ackrcShortFlag "\(^\|\s\)\zs-[a-zA-Z0-9]\+"

" Ignore directory options & directory targets
syn match ackrcIgnoreDirOption "--\%(no-\?\)\?ignore-dir\%(ectory\)\?" nextgroup=ackrcIgnoreDirAssign
syn match ackrcIgnoreDirAssign "=" contained nextgroup=ackrcDirectoryName
syn match ackrcDirectoryName "[^#\r\n\t ]\+" contained contains=ackrcExtension

" Ignore file option
syn match ackrcDirective "--ignore-file"

" Type definition options and type names
syn match ackrcTypeOption "--type-\%(set\|add\)" nextgroup=ackrcTypeAssign
syn match ackrcTypeAssign "=" contained nextgroup=ackrcTypeName
syn match ackrcTypeName "[a-zA-Z0-9_-]\+" contained nextgroup=ackrcTypeSep
syn match ackrcTypeSep "[=:]" contained

syn match ackrcTypeDelOption "--type-del" nextgroup=ackrcTypeDelAssign
syn match ackrcTypeDelAssign "=" contained nextgroup=ackrcTypeNameDel
syn match ackrcTypeNameDel "[a-zA-Z0-9_-]\+" contained

syn match ackrcTypeFilterOption "--type\ze=" nextgroup=ackrcTypeFilterAssign
syn match ackrcTypeFilterAssign "=" contained nextgroup=ackrcTypeNameDel

syn match ackrcTypeShortOption "\<-[tT]\s\+" nextgroup=ackrcTypeNameDel
syn match ackrcTypeLongOption "--type\s\+" nextgroup=ackrcTypeNameDel

" Color modifiers
syn keyword ackrcModifierBold contained bold
syn keyword ackrcModifierItalic contained italic
syn keyword ackrcModifierUnderline contained underline
syn keyword ackrcModifier contained faint blink reverse concealed

" Foreground colors
syn keyword ackrcColorBlack contained black
syn keyword ackrcColorRed contained red
syn keyword ackrcColorGreen contained green
syn keyword ackrcColorYellow contained yellow
syn keyword ackrcColorBlue contained blue
syn keyword ackrcColorMagenta contained magenta
syn keyword ackrcColorCyan contained cyan
syn keyword ackrcColorWhite contained white

" Background colors
syn keyword ackrcBgColorBlack contained on_black
syn keyword ackrcBgColorRed contained on_red
syn keyword ackrcBgColorGreen contained on_green
syn keyword ackrcBgColorYellow contained on_yellow
syn keyword ackrcBgColorBlue contained on_blue
syn keyword ackrcBgColorMagenta contained on_magenta
syn keyword ackrcBgColorCyan contained on_cyan
syn keyword ackrcBgColorWhite contained on_white

" RGB colors
syn match ackrcRgbColor contained "\(on_\)\?rgb[0-5]\{3\}"

" Special / defaults
syn keyword ackrcColorDefault contained default none reset

syn cluster ackrcColors contains=ackrcModifierBold,ackrcModifierItalic,ackrcModifierUnderline,ackrcModifier,ackrcColorBlack,ackrcColorRed,ackrcColorGreen,ackrcColorYellow,ackrcColorBlue,ackrcColorMagenta,ackrcColorCyan,ackrcColorWhite,ackrcBgColorBlack,ackrcBgColorRed,ackrcBgColorGreen,ackrcBgColorYellow,ackrcBgColorBlue,ackrcBgColorMagenta,ackrcBgColorCyan,ackrcBgColorWhite,ackrcRgbColor,ackrcColorDefault

" Color options & Color values
syn match ackrcColorOption "--color-\%(filename\|match\|lineno\|colno\)" nextgroup=ackrcColorAssign
syn match ackrcColorOption "ACK_COLOR_\%(FILENAME\|MATCH\|LINENO\|COLNO\)" nextgroup=ackrcColorAssign
syn match ackrcColorAssign "=" contained nextgroup=ackrcColorValue
syn match ackrcColorValue "[^#\r\n]\+" contained contains=ackrcString,ackrcComment,@ackrcColors

" Default highlight links (standard Vim groups)
hi def link ackrcDirective Statement
hi def link ackrcIgnoreDirOption Statement
hi def link ackrcIgnoreDirAssign Delimiter
hi def link ackrcDirectoryName Directory
hi def link ackrcTypeOption Statement
hi def link ackrcTypeAssign Delimiter
hi def link ackrcTypeSep Delimiter
hi def link ackrcTypeDelOption Statement
hi def link ackrcTypeDelAssign Delimiter
hi def link ackrcTypeFilterOption Statement
hi def link ackrcTypeFilterAssign Delimiter
hi def link ackrcTypeShortOption Statement
hi def link ackrcTypeLongOption Statement
hi def link ackrcTypeName Identifier
hi def link ackrcTypeNameDel Identifier
hi def link ackrcColorOption Special
hi def link ackrcColorAssign Delimiter
hi def link ackrcFlag Keyword
hi def link ackrcShortFlag Keyword
hi def link ackrcFilterType Type
hi def link ackrcExtension String
hi def link ackrcRegex Special
hi def link ackrcRegexEscape SpecialChar
hi def link ackrcEscape SpecialChar
hi def link ackrcDelimiter Delimiter
hi def link ackrcComma Delimiter
hi def link ackrcNumber Number
hi def link ackrcComment Comment
hi def link ackrcTodo Todo
hi def link ackrcString String
hi def link ackrcModifierBold Bold
hi def link ackrcModifierItalic Italic
hi def link ackrcModifierUnderline Underline
hi def link ackrcModifier PreProc
hi def link ackrcColorDefault Constant
hi def link ackrcRgbColor Special

" Fallback links for color names if colorscheme does not provide specific overrides
hi def link ackrcColorBlack Comment
hi def link ackrcColorRed String
hi def link ackrcColorGreen Identifier
hi def link ackrcColorYellow Constant
hi def link ackrcColorBlue Function
hi def link ackrcColorMagenta Statement
hi def link ackrcColorCyan Special
hi def link ackrcColorWhite Normal

let b:current_syntax = "ackrc"

let &cpo = s:cpo_save
unlet s:cpo_save
