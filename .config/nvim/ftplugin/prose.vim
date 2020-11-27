" ---------------------
" NEOVIM PROSE FILETYPE
" ---------------------

" SETTINGS
" --------

setlocal noautoindent
setlocal nobreakindent
setlocal nosmartindent
setlocal nocindent
setlocal noexpandtab
setlocal wrap
setlocal linebreak
setlocal scrolloff=0
setlocal display=lastline
setlocal nolist
setlocal nonumber
setlocal nocursorline

" SPELLCHECKING
" -------------

setlocal spell
setlocal spelllang=pl,en_us
setlocal spellsuggest+=5
let &spellfile=expand('%:p:h').'/pl.add' " Spellfile in the same dir as the file itself

" MAPS
" ----

iabbrev <buffer> -- —
nnoremap <buffer><silent> <leader>f :Goyo<CR>
nnoremap <buffer> j gj
nnoremap <buffer> k gk

let b:did_ftplugin = 1
