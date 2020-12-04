" PROSE FTPLUGIN
" --------------
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
setlocal norelativenumber
setlocal nocursorline
setlocal spell
setlocal spelllang=pl,en_us
setlocal spellsuggest+=5

let &spellfile=expand('%:p:h').'/pl.add'

iabbrev <buffer> -- —
nnoremap <buffer> j gj
nnoremap <buffer> k gk
