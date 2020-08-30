" Nord theme
colorscheme nord
let g:nord_uniform_diff_background = 1
let g:nord_bold = 0
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
let g:nord_cursor_line_number_background = 1

" Lightline status bar configuration
let g:lightline = {
        \ 'colorscheme': 'nord',
        \ 'active': {
        \       'left': [ [ 'mode', 'paste' ],
        \                 [ 'readonly', 'filename', 'modified' ] ],
        \       'right': [ [ 'gitbranch', 'filetype', 'lineinfo'] ]
        \ },
        \ 'inactive': {
        \       'right': [ [ 'gitbranch', 'filetype', 'lineinfo'] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'FugitiveHead'
        \ },
        \ }

"Indentline configuration
let g:indentLine_color_term = 0
let g:indentLine_char = '|'

