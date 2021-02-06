" MARKDOWN NOTES DETECTION
" ------------------------
autocmd BufRead,BufNewFile *.html if getline(2) =~ '<script src="https://cdn.jsdelivr.net/npm/texme"></script>' | set filetype=markdown | endif
