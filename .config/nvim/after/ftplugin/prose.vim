" PROSE FTPLUGIN
" --------------
setlocal noautoindent nobreakindent nosmartindent nocindent
setlocal noexpandtab wrap linebreak scrolloff=0
setlocal nolist nonumber norelativenumber nocursorline
setlocal spell spelllang=pl,en_us spellsuggest+=5

let &l:spellfile=expand('%:p:h').'/pl.add'

iabbrev <buffer> -- —
nnoremap <buffer> j gj
nnoremap <buffer> k gk
