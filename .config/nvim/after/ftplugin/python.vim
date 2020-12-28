" PYTHON FTPLUGIN
" ---------------
setlocal makeprg=python3\ %
compiler pyunit
let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

" Uncomment for linting/formatting without LSP
" setlocal makeprg=pylint\ --output-format=parseable\ %
" setlocal equalprg=yapf
" setlocal formatprg=yapf

