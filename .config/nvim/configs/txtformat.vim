" .txt file formatting
autocmd BufRead,BufNewFile *.txt setlocal textwidth=80
autocmd BufRead,BufNewFile *.txt setlocal formatoptions=awt
autocmd BufRead,BufNewFile *.txt setlocal noautoindent
autocmd BufRead,BufNewFile *.txt setlocal nosmartindent
autocmd BufRead,BufNewFile *.txt setlocal nocindent
autocmd BufRead,BufNewFile *.txt setlocal conceallevel=0
