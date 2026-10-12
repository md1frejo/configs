" custom_light.vim
" Warm paper high-contrast light theme
" Converted from Neovim Lua theme

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "custom_light"

set background=light

" =========================
" Base colors
" =========================

let s:bg      = "#fffef6"
let s:bg_alt  = "#f5f1e8"
let s:sel     = "#c7e0ff"
let s:fg      = "#1a1a1a"
let s:comment = "#4a4a4a"

let s:blue    = "#004b8d"
let s:blue2   = "#0057d9"
let s:purple  = "#4c1d95"
let s:green   = "#1b7f3a"
let s:cyan    = "#0047ab"
let s:red     = "#b00020"
let s:orange  = "#8a5a00"


" =========================
" UI
" =========================

execute "hi Normal guifg=" . s:fg . " guibg=" . s:bg

hi CursorLine guibg=#f5f7fa

hi LineNr guifg=#8a8a8a
hi CursorLineNr guifg=#000000 gui=bold

hi Visual guibg=#c7e0ff

hi Search guifg=#ffffff guibg=#ff3b30 gui=bold
hi IncSearch guifg=#000000 guibg=#ffd60a

hi StatusLine guifg=#000000 guibg=#e6e6e6
hi StatusLineNC guifg=#666666 guibg=#f0f0f0

hi VertSplit guifg=#c0c0c0

execute "hi Directory guifg=" . s:blue


" =========================
" Syntax
" =========================

execute "hi Comment guifg=" . s:comment . " gui=italic"

execute "hi String guifg=" . s:green

execute "hi Number guifg=" . s:blue2 . " gui=bold"

execute "hi Constant guifg=" . s:blue2 . " gui=bold"

execute "hi Identifier guifg=" . s:blue

execute "hi Function guifg=" . s:purple . " gui=bold"

execute "hi Keyword guifg=" . s:red . " gui=bold"

execute "hi Type guifg=" . s:orange . " gui=bold"

execute "hi PreProc guifg=" . s:cyan


" =========================
" Completion menus
" =========================

hi Pmenu guifg=#1a1a1a guibg=#f5f1e8

hi PmenuSel guifg=#000000 guibg=#c7e0ff gui=bold

hi PmenuThumb guibg=#c0c0c0


" =========================
" Diff
" =========================

hi DiffAdd guibg=#d4f8d4
hi DiffDelete guibg=#ffd6d6
hi DiffChange guibg=#fff3b0


" =========================
" Diagnostics (Neovim compatible names ignored by Vim)
" =========================

hi ErrorMsg guifg=#b00020
hi WarningMsg guifg=#8a5a00


" =========================
" HTML
" =========================

hi htmlTag guifg=#004b8d
hi htmlTagName guifg=#004b8d
hi htmlArg guifg=#b00020

hi xmlTag guifg=#004b8d
hi xmlTagName guifg=#004b8d
hi xmlAttrib guifg=#b00020


" =========================
" JavaScript / TypeScript
" =========================

hi javaScriptFunction guifg=#4c1d95 gui=bold
hi javaScriptIdentifier guifg=#004b8d
hi javaScriptNumber guifg=#0057d9 gui=bold
hi javaScriptString guifg=#1b7f3a


" =========================
" CSS
" =========================

hi cssPropertyName guifg=#004b8d
hi cssValueNumber guifg=#0057d9
hi cssStringQ guifg=#1b7f3a
hi cssTagName guifg=#4c1d95


" =========================
" Markdown
" =========================

hi markdownHeadingDelimiter guifg=#b00020
hi markdownHeading guifg=#004b8d gui=bold

hi markdownCode guifg=#1b7f3a
hi Comment guifg=#4a4a4a gui=italic

" =========================
" Git
" =========================

hi DiffText guibg=#fff3b0


" =========================
" Terminal colors
" =========================

let g:terminal_color_0  = "#1a1a1a"
let g:terminal_color_1  = "#b00020"
let g:terminal_color_2  = "#1b7f3a"
let g:terminal_color_3  = "#8a5a00"
let g:terminal_color_4  = "#004b8d"
let g:terminal_color_5  = "#4c1d95"
let g:terminal_color_6  = "#0047ab"
let g:terminal_color_7  = "#fffef6"

let g:terminal_color_8  = "#666666"
let g:terminal_color_9  = "#ff3b30"
let g:terminal_color_10 = "#2e8b57"
let g:terminal_color_11 = "#ffd60a"
let g:terminal_color_12 = "#0057d9"
let g:terminal_color_13 = "#6d28d9"
let g:terminal_color_14 = "#0066cc"
let g:terminal_color_15 = "#ffffff"
