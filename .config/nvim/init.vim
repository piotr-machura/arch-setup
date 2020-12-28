" -----------------------------
" NEOVIM TERMINAL EDITOR CONFIG
" -----------------------------

if !filereadable(stdpath('data').'/site/autoload/plug.vim') " Auto-install vim-plug
    silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" PLUGINS
" -------
call plug#begin(stdpath('data').'/vim-plug')
Plug 'mbbill/undotree' " Undo tree visualized
Plug 'junegunn/vim-peekaboo' " Registers visualized
Plug 'jiangmiao/auto-pairs' " Auto pairs for brackets/quotes
Plug 'tpope/vim-surround' " Change surrounding brackets/quotes
Plug 'tpope/vim-commentary' " Comment automation
Plug 'tpope/vim-repeat' " Repeat surroundings/commentary with '.'
Plug 'sheerun/vim-polyglot' " Multi-language pack
Plug 'arcticicestudio/nord-vim' " Theme
Plug 'Yggdroot/indentLine' " Indentation line indicators
Plug 'junegunn/goyo.vim' " Distraction-free mode
Plug 'neovim/nvim-lspconfig' " Native LSP client implementation
Plug 'nvim-lua/completion-nvim' " Native LSP completion window
call plug#end()

" LUA
" ---
lua require('lspconf')

" SETTINGS
" --------
set tabstop=4   softtabstop=4   shiftwidth=4    expandtab   shiftround
set path=.,**   smartcase       completeopt=menuone,noinsert,noselect
set confirm     updatetime=500  shortmess+=cI   virtualedit=block
set nowrap      cursorline      scrolloff=4     sidescrolloff=6
set undofile    undolevels=500  autowrite       signcolumn=yes
set hidden      conceallevel=2  concealcursor=  mouse+=ar
set list        fcs=eob:\       lcs=tab:>-,trail:·
set splitbelow  splitright      switchbuf=usetab

" Title
set titlelen=0 title
set titlestring=
set titlestring+=%{\"\\ue62b\ \".substitute(getcwd(),$HOME,'~','')}
set titlestring+=%{\"\\uf460\".fnamemodify(expand('%'),':~:.')}

" Statusline
set statusline=
set statusline+=%#StatusLineNC#%=%1*%{StatuslineDiagnostics()}%*
set statusline+=\ %{&readonly\ &&\ &modifiable\ ?\ \"\\uf05e\ Read-only\ \|\ \"\ :\ ''}
set statusline+=%{&modified\ &&\ &modifiable\ ?\ \"\\uf44d\ \"\ :\ ''}
set statusline+=%{!empty(expand('%'))\ ?\ fnamemodify(expand('%'),':~:.').'\ \|\ ':''}
set statusline+=%{\"\\ufc92\"}\ %c\ %{\"\\uf1dd\"}\ %l\ %{\"\\uf719\"}\ %n\ %<

" Disable plugins
let g:loaded_netrwPlugin = 1
let g:loaded_matchit = 1

" Undoo tree configuration
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2
let g:undotree_HelpLine = 0
let g:undotree_ShortIndicators = 1
let g:undotree_CursorLine = 1
let g:undotree_DiffpanelHeight = 6
let g:undotree_Splitwidth = 20

" Indentline configuration
let g:indentLine_color_term = 8
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_char = "\u2506"
let g:indentLine_first_char = "\u2506"
let g:indentLine_setConceal = 0
let g:indentLine_bufTypeExclude = ['help', 'term']
let g:indentLine_fileTypeExclude = ['undotree',  'diff', 'peekaboo' ]

"Theme configuration
let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_underline = 1

call sign_define('LspDiagnosticsSignError', {'text':"\uf057", 'texthl':'LspDiagnosticsDefaultError'})
call sign_define('LspDiagnosticsSignWarning', {'text':"\uf06a", 'texthl':'LspDiagnosticsDefaultWarning'})
call sign_define('LspDiagnosticsSignInformation', {'text':"\uf059", 'texthl':'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsSignHint', {'text' : "\uf055", 'texthl':'LspDiagnosticsDefaultHint'})

" Completion popup configuration
let g:completion_enable_auto_popup = 0
let g:completion_enable_auto_signature = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_paren = 1
let g:completion_matching_smart_case = 1
let g:completion_matching_strategy_list = ['exact', 'substring']
let g:completion_sorting = 'alphabet'

" CLIPBOARD
" ---------
let g:clipboard = {
    \ 'name': 'xclip',
    \ 'copy': {'+': 'xclip -selection clipboard', '*': 'xclip -selection clipboard'},
    \ 'paste': {'+': 'xclip -selection clipboard -o', '*': 'xclip -selection clipboard -o'},
    \ 'cache_enabled': 1,
    \ }
set clipboard+=unnamedplus

" MAPS
" ----
let g:mapleader = "\<Space>"

" Buffer management
nnoremap <expr> ZZ &modified ? "\<CMD>write\<Bar>bdelete!\<CR>" : "\<CMD>bdelete!\<CR>" 
nnoremap <expr> ZQ &modified ? "\<CMD>write\<Bar>quit!\<CR>" : "\<CMD>quit!\<CR>"
nnoremap gb <CMD>bnext<CR>
nnoremap gB <CMD>bprev<CR>
nnoremap - :find<Space>

" Line splitting from normal mode
nnoremap [<CR> O<ESC>
nnoremap ]<CR> o<ESC>
nnoremap K a<CR><ESC>

" Insert mode completion
inoremap <expr> <C-Space> pumvisible() ? "\<C-e>" : "\<C-n>"
inoremap <expr> <C-n> pumvisible() ? "\<C-e>" : "\<C-n>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Disable middle mouse click
noremap <MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>
cnoremap <MiddleMouse> <Nop>

" Jump, location and quickfix lists
nnoremap <S-Tab> <C-o>
nnoremap gj <CMD>jumps<CR>
nnoremap [l <CMD>lprev<CR>
nnoremap ]l <CMD>lnext<CR>
noremap gl <CMD>llist<CR>
nnoremap [q <CMD>cprev<CR>
nnoremap ]q <CMD>cnext<CR>
noremap gq <CMD>clist<CR>

" Terminal
tnoremap <C-\> <C-\><C-n>
noremap <expr> <C-\> &buftype == 'terminal' ? "\<CMD>startinsert\<CR>" : "\<CMD>terminal\<CR>"
nnoremap _ <CMD>terminal tree<CR><C-\><C-n>

" Utilities
nmap r <leader>r
nnoremap <leader>r #:%s///gc<Left><Left><Left>
noremap = <CMD>call <SID>format_buffer()<CR>
nnoremap <C-u> <CMD>UndotreeToggle<CR>
let g:AutoPairsShortcutToggle = "\<C-p>"

" Other maps
nnoremap <C-h> K
nnoremap Q @q
noremap <Del> "_
nnoremap <leader>g <CMD>Goyo<CR>
nnoremap <leader><Space> <CMD>nohlsearch<Bar>mode<Bar>call <SID>wipe_empty()<CR>

" FUNCTIONS
" ---------
function! s:format_buffer() abort
    let c_line = line('.')
    let c_col = col('.')
    let msg = ''
    if luaeval('vim.lsp.buf.server_ready()')
        lua vim.lsp.buf.formatting()
        let msg .= 'Formatted buffer. '
    else
        if !empty(&formatprg)
            silent! normal! gggqG
            let msg .= 'Formatted buffer. '
        endif
        if !empty(&equalprg)
            silent! normal! gg=G
            if empty(msg) | let msg .= 'Formatted buffer. ' | endif
        endif
    endif
    let last_search = @/
    silent! %substitute/\s\+$//e
    let @/ = last_search
    nohlsearch
    unlet last_search
    let msg .= 'Stripped trailing whitespace.'
    echo msg
    call cursor(c_line, c_col)
endfunction

function! s:wipe_empty() abort
    let con =  'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")'
    let buffers = filter(range(1, bufnr('$')), con)
    if !empty(buffers)
        execute 'bwipeout ' . join(buffers, ' ')
    endif
endfunction

function! StatuslineDiagnostics() abort
    let msgs = ''
    if winwidth(0) < 80 | return msgs | endif
    let errors = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Error]])')
    let warnings = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Warning]])')
    let infos = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Information]])')
    let hints = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Hint]])')
    if errors > 0 | let msgs .= " \uf057 " . errors | endif
    if warnings > 0 | let msgs .= " \uf06a " . warnings | endif
    if infos > 0 | let msgs .= " \uf059 " . infos | endif
    if hints > 0 | let msgs .=  " \uf055 " . hints | endif
    if !empty(msgs) | let msgs .= ' '| endif
    return msgs
endfunction

" AUTOCMDS
" --------
augroup init_vim
    autocmd!
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal statusline=%1*%=%{\"\\uf44f\ Terminal\"}%=
    autocmd FileType qf setlocal statusline=%1*%=%{\"\\uf4a0\ \ Quickfix\"}%=
    autocmd FileType help setlocal statusline=%1*%=%{\"\\uf7d6\ \ Help\ -\ \".expand('%:t')}%=
    autocmd FileType diff setlocal statusline=%#StatusLineNC#
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd FileType peekaboo setlocal statusline=%1*%=%{\"\\uf64d\"}%=
    autocmd VimResized * if exists('#goyo') | execute "normal \<C-W>=" | endif
    autocmd ColorScheme * highlight User1 ctermbg=None ctermfg=7
        \ | highlight StatusLine ctermbg=8 ctermfg=7
        \ | highlight StatusLineNC ctermbg=None ctermfg=8
        \ | highlight Search cterm=bold,underline ctermfg=6 ctermbg=8
        \ | highlight TabLineFill ctermbg=None
        \ | highlight TabLineSel ctermfg=7
        \ | highlight ModeMsg cterm=bold ctermfg=7
        \ | highlight link MsgSeparator StatusLineNC
        \ | highlight link LspDiagnosticsDefaultError LSPDiagnosticsError
        \ | highlight link LspDiagnosticsDefaultWarning LSPDiagnosticsWarning
        \ | highlight link LspDiagnosticsDefaultInformation LSPDiagnosticsInformation
        \ | highlight link LspDiagnosticsDefaultHint LSPDiagnosticsHint
augroup END

" COLORSCHEME
" -----------
colorscheme nord
