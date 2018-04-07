setlocal formatoptions+=1 " Don't break lines after a one-letter word
setlocal formatoptions+=a " Autoformat paragraphs when inserting/deleting text
setlocal formatoptions+=b " Auto-wrap if line ends with whitespace
setlocal formatoptions+=j " Remove comment leader when joining lines
setlocal formatoptions+=l " Don't wrap lines that are too long when starting Insert mode
setlocal formatoptions+=n " Recognize numbered lists
setlocal formatoptions+=o " Set cursor when inserting a new line from Normal mode
setlocal formatoptions+=q " Allow formatting of comments with 'gq'.
setlocal formatoptions+=r " Insert comment leader after hitting <Enter>
setlocal formatoptions+=t " Auto-wrap text using textwidth
setlocal formatoptions+=w " Whitespace at EOL signifies next line continues paragraph
setlocal formatoptions-=2 " Auto-wrap based on 2nd line of paragraph
setlocal formatoptions-=c " Insert comment character when auto-wrapping a comment

" setlocal formatoptions=1abjlnoqrtw
let g:markdown_syntax_conceal = 0
