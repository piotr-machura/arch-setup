" PYTHON FTPLUGIN
" ---------------
setlocal makeprg=python3\ %
compiler pyunit
let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0
let g:lua_tree_ignore += [ '__pycache__', '.venv']
