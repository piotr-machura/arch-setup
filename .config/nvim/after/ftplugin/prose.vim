" PROSE FTPLUGIN
" --------------
setlocal noautoindent nobreakindent nosmartindent nocindent
setlocal shiftwidth=2 softtabstop=2
setlocal wrap linebreak scrolloff=0
setlocal nolist nonumber norelativenumber nocursorline
setlocal spell spelllang=pl,en_us spellsuggest+=5

let &l:spellfile=expand('%:p:h') . '/.words/utf-8.add'
if !filereadable(&l:spellfile . '.spl')
    exec 'silent! mkspell ' . &l:spellfile
endif

inoreabbrev <buffer> -- ―
inoreabbrev <buffer> ... …<Left><Left><Del><Right>

noremap <buffer> j gj
noremap <buffer> k gk
noremap <buffer> <Down> g<Down>
noremap <buffer> <Up> g<Up>
let g:indentLine_fileTypeExclude+=['prose']

function! s:fix_formatting()
    silent! %s/\.\.\./…/g
    silent! %s/’/'/g
    silent! %s/\n\n\n/\r\r/g
    silent! %s/”\|„\|''\|,,/"/g
    silent! %s/- \|– /― /g
    silent! %s/[\x0]//g
endfunction

command! FixFormatting call <SID>fix_formatting()
