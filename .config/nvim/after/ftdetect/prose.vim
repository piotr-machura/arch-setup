" PROSE FILETYPE DETECTION
" ------------------------
autocmd BufRead,BufNewFile *.txt if isdirectory(expand('%:p:h').'/.words') | set filetype=prose | endif
