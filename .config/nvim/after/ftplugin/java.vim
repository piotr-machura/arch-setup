" JAVA FTPLUGIN
" -------------
let java_highlight_functions = 1
let java_highlight_all = 1

set wildignore+=*.class,target,bin,classes
setlocal makeprg=mvn\ clean\ compile
setlocal errorformat=\[ERROR]\ %f:%l:\ %m,%-G%.%#
