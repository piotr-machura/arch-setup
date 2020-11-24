" ---------------------
" NEOVIM PROSE FILETYPE
" ---------------------
" Note: source this in init.vim and run :PlugInstall
" in order to get prose filetype functionality

call plug#begin(stdpath('data').'/vim-plug')
Plug 'junegunn/goyo.vim' " Distraction-free mode
call plug#end()

function s:prose_ftplugin() abort
    " Spellfile in the same dir as the file itself
    let &spellfile=expand('%:p:h').'/pl.add'
    setlocal spell spelllang=pl,en_us spellsuggest+=5
    " Put dialogue dash instead of --
    iabbrev <buffer> -- —
    setlocal noautoindent nobreakindent nosmartindent nocindent noexpandtab
    setlocal wrap linebreak scrolloff=0 display=lastline nolist nonumber
    " Conceal the call to vim filetype
    syntax match Normal '# vim: set filetype=prose:' conceal
    " Keyboard shortcuts
    nnoremap <buffer><silent> <leader>f :Goyo<CR>
    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
endfunction

augroup prose
    autocmd!
    autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
    autocmd FileType prose call <SID>prose_ftplugin()
augroup END
