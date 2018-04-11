" Copyright (c) 2016-present Arctic Ice Studio <development@arcticicestudio.com>
" Copyright (c) 2016-present Sven Greb <code@svengreb.de>

" Project: Nord Vim
" Repository: https://github.com/arcticicestudio/nord-vim
" License: MIT

let s:nord_vim_version='0.8.3'
let g:airline#themes#nord#palette = {}

let s:nord00_gui = '#2E3440' | let s:nord00_term = 'NONE'
let s:nord01_gui = '#3B4252' | let s:nord01_term = '0'
let s:nord02_gui = '#434C5E' | let s:nord02_term = 'NONE'
let s:nord03_gui = '#4C566A' | let s:nord03_term = '8'
let s:nord04_gui = '#D8DEE9' | let s:nord04_term = 'NONE'
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

let s:NMain = [s:nord01_gui, s:nord08_gui, s:nord01_term, s:nord08_term]
let s:NRight = [s:nord01_gui, s:nord09_gui, s:nord01_term, s:nord09_term]
let s:NMiddle = [s:nord04_gui, s:nord03_gui, s:nord04_term, s:nord03_term]

let g:airline#themes#nord#palette.normal = airline#themes#generate_color_map(s:NMain, s:NRight, s:NMiddle)

let s:IMain = [s:nord01_gui, s:nord14_gui, s:nord01_term, s:nord06_term]
let s:IRight = [s:nord01_gui, s:nord09_gui, s:nord01_term, s:nord09_term]
let s:IMiddle = [s:nord04_gui, s:nord03_gui, s:nord04_term, s:nord03_term]

let g:airline#themes#nord#palette.insert = airline#themes#generate_color_map(s:IMain, s:IRight, s:IMiddle)

let s:RMain = [s:nord01_gui, s:nord14_gui, s:nord01_term, s:nord14_term]
let s:RRight = [s:nord01_gui, s:nord09_gui, s:nord01_term, s:nord09_term]
let s:RMiddle = [s:nord04_gui, s:nord03_gui, s:nord04_term, s:nord03_term]

let g:airline#themes#nord#palette.replace = airline#themes#generate_color_map(s:RMain, s:RRight, s:RMiddle)

let s:VMain = [s:nord01_gui, s:nord07_gui, s:nord01_term, s:nord07_term]
let s:VRight = [s:nord01_gui, s:nord09_gui, s:nord01_term, s:nord09_term]
let s:VMiddle = [s:nord04_gui, s:nord03_gui, s:nord04_term, s:nord03_term]

let g:airline#themes#nord#palette.visual = airline#themes#generate_color_map(s:VMain, s:VRight, s:VMiddle)

let s:IAMain = [s:nord04_gui, s:nord03_gui, s:nord04_term, s:nord03_term]
let s:IARight = [s:nord04_gui, s:nord03_gui, s:nord04_term, s:nord03_term]
let s:IAMiddle = [s:nord04_gui, s:nord01_gui, s:nord04_term, s:nord01_term]

let g:airline#themes#nord#palette.inactive = airline#themes#generate_color_map(s:IAMain, s:IARight, s:IAMiddle)
