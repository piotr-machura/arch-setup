" PYTHON FTPLUGIN
" ---------------
command! -nargs=0 Lint :term pylint %
setlocal makeprg=/usr/bin/python3\ %
compiler pyunit
