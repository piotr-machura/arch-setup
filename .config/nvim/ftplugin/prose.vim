" ---------------------
" NEOVIM PROSE FILETYPE
" ---------------------

let b:did_ftplugin = 1

" Enable spellchacking
setlocal spell spelllang=pl,en_us spellsuggest+=5

" Spellfile in the same dir as the file itself
let &spellfile=expand('%:p:h').'/pl.add'

" Put dialogue dash instead of --
iabbrev <buffer> -- —

" Remove all indentation
setlocal noautoindent nobreakindent nosmartindent nocindent noexpandtab

" Wrap long lines
setlocal wrap linebreak scrolloff=0 display=lastline nolist nonumber

" Keyboard shortcuts
nnoremap <buffer><silent> <leader>f :Goyo<CR>
nnoremap <buffer> j gj
nnoremap <buffer> k gk
