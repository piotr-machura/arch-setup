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

inoreabbrev <buffer> -- –

noremap <buffer> j gj
noremap <buffer> k gk
noremap <buffer> <Down> g<Down>
noremap <buffer> <Up> g<Up>

let g:indentLine_fileTypeExclude+=['prose']

function! s:fix_formatting()
    let c_line = line('.')
    let c_col = col('.')
    silent! keepjumps %s/\.\.\./…/g
    silent! keepjumps %s/’/'/g
    silent! keepjumps %s/\n\n\n/\r\r/g
    silent! keepjumps %s/”\|„\|''\|,,/"/g
    silent! keepjumps %s/\t- \|\t― /\t– /g
    silent! keepjumps %s/ - \| ― \| -- / – /g
    silent! keepjumps %s/[\x0]//g
    call cursor(c_line, c_col)
endfunction

command! FixFormatting call <SID>fix_formatting()
