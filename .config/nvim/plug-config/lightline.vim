" Lightline status line
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
