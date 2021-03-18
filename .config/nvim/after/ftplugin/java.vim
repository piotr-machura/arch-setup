" JAVA FTPLUGIN
" -------------
let java_highlight_functions = 1
let java_highlight_all = 1

highlight link javaScopeDecl Statement
highlight link javaType Type
highlight link javaLangClass Structure
highlight link javaDocTags PreProc
highlight mkdListItemLine guibg=None

set makeprg=mvn\ clean\ compile
set errorformat=\[ERROR]\ %f:%l:\ %m,%-G%.%#
set wildignore+=*.class,target,bin,classes
