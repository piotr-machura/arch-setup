" NERDtree 
" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
" Close when there is only nerdtree open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Avoid problems with vim-plug opening the window on a nerdtree
let g:plug_window = 'noautocmd vertical topleft new'
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 0
map <C-n> :NERDTreeToggle<CR>
" Fix borked colors in nerdtree
autocmd BufEnter * highlight! link NERDTreeFlags NERDTreeDir
" Git status symbols
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'*',
                \ 'Staged'    :'',
                \ 'Untracked' :'?',
                \ 'Renamed'   :'',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'',
                \ 'Dirty'     :'',
                \ 'Ignored'   :'',
                \ 'Clean'     :'',
                \ 'Unknown'   :'',
                \ }
let g:NERDTreeGitStatusConcealBrackets = 0

