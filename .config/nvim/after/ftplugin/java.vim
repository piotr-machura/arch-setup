" JAVA FTPLUGIN
" -------------
let java_highlight_functions = 1
let java_highlight_all = 1

setlocal path=src/**
setlocal makeprg=mvn\ -gs\ $XDG_CONFIG_HOME/mvn/settings.xml\ clean\ compile
setlocal errorformat=\[ERROR]\ %f:%l:\ %m,%-G%.%#