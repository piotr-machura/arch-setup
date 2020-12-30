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
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'mbbill/undotree'
Plug 'junegunn/vim-peekaboo'
Plug 'ap/vim-css-color'
Plug 'arcticicestudio/nord-vim'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/goyo.vim'
call plug#end()

" LUA
" ---
lua require('lspconf')

" SETTINGS
" --------
set tabstop=4   softtabstop=4   shiftwidth=4    expandtab   shiftround
set noruler     nowrap          updatetime=500  shortmess+=cI
set undofile    undolevels=500  autowrite       helpheight=5
set hidden      conceallevel=2  concealcursor=  mouse+=ar
set nonumber    signcolumn=yes  norelativenumber
set splitbelow  splitright      switchbuf=usetab
set cursorline  scrolloff=2     sidescrolloff=6
set list        fcs=eob:\       lcs=tab:>-,trail:·
set path=.,**   smartcase       completeopt=menuone,noinsert,noselect
set title       titlelen=0      titlestring=%{_TitleString()}
set tabline=%!_Tabline()        statusline=%=%{_StatusLine()}%<
set virtualedit=block           clipboard+=unnamedplus

" Disable included plugins
let g:loaded_netrwPlugin = 1
let g:loaded_matchit = 1

" Undoo tree configuration
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2
let g:undotree_HelpLine = 0
let g:undotree_ShortIndicators = 1
let g:undotree_CursorLine = 1
let g:undotree_DiffpanelHeight = 6

call sign_define('UndotreeAdd', {'text':'+' , 'texthl':'DiffAdd'})
call sign_define('UndotreeChg', {'text':'~' , 'texthl':'DiffChange'})
call sign_define('UndotreeDel', {'text':'-' , 'texthl':'DiffDelete'})
call sign_define('UndotreeDelEnd', {'text':"\u2015" , 'texthl':'DiffDelete'})

" Indentline configuration
let g:indentLine_color_term = 8
let g:indentLine_color_gui = '#4C566A'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_char = "\u2506"
let g:indentLine_first_char = "\u2506"
let g:indentLine_setConceal = 0
let g:indentLine_bufTypeExclude = ['help', 'term']
let g:indentLine_fileTypeExclude = ['undotree',  'diff', 'peekaboo', 'vim-plug' ]

"Theme configuration
let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_underline = 1

" Completion popup configuration
let g:completion_enable_auto_popup = 0
let g:completion_enable_auto_signature = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_paren = 1
let g:completion_matching_smart_case = 1
let g:completion_matching_strategy_list = ['exact', 'substring']
let g:completion_sorting = 'alphabet'
let g:completion_confirm_key = ''

call sign_define('LspDiagnosticsSignError', {'text':"\uf057", 'texthl':'LspDiagnosticsDefaultError'})
call sign_define('LspDiaget osticsSignWarning', {'text':"\uf06a", 'texthl':'LspDiagnosticsDefaultWarning'})
call sign_define('LspDiagnosticsSignInformation', {'text':"\uf059", 'texthl':'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsSignHint', {'text' : "\uf055", 'texthl':'LspDiagnosticsDefaultHint'})

" MAPS
" ----
let g:mapleader = "\<Space>"

nnoremap <S-Tab> <C-o>
nnoremap - :find<Space>
nnoremap <C-h> K
nnoremap K a<CR><ESC>
nnoremap Q @q
noremap <Del> "_
nnoremap [<CR> O<ESC>
nnoremap ]<CR> o<ESC>
tnoremap <C-\> <C-\><C-n>

noremap = <CMD>call <SID>format_buffer()<CR>
nnoremap _ <CMD>terminal tree<CR><C-\><C-n>
nnoremap <leader>h <CMD>echo <SID>highlight_group()<CR>
nnoremap <leader>g <CMD>Goyo<CR>
nnoremap <leader>u <CMD>UndotreeToggle<CR>
nnoremap <leader><Space> <CMD>nohlsearch<Bar>mode<Bar>call <SID>wipe_empty()<CR>
noremap <expr> <C-\> &buftype == 'terminal' ? "\<CMD>startinsert\<CR>" : ''
nnoremap <expr> ZZ &modified ? "\<CMD>write\<Bar>bdelete!\<CR>" : "\<CMD>bdelete!\<CR>"
nnoremap <expr> ZQ &modified ? "\<CMD>write\<Bar>quit!\<CR>" : "\<CMD>quit!\<CR>"

" Insert mode completion
inoremap <expr> <C-Space> pumvisible() ? "\<C-e>" : "\<C-n>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Location and quickfix lists
nnoremap [l <CMD>lprev<CR>
nnoremap ]l <CMD>lnext<CR>
nnoremap gl <CMD>llist<CR>
nnoremap [q <CMD>cprev<CR>
nnoremap ]q <CMD>cnext<CR>
noremap gq <CMD>clist<CR>

" Replace under cursor
nmap <leader>r <leader>R
nnoremap <leader>R #:%s///gc<Left><Left><Left>

" Disable middle mouse click
noremap <MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>
cnoremap <MiddleMouse> <Nop>

" FUNCTIONS
" ---------
function! _StatusLine() abort
    let statusline = ''
    " LSP diagnostics
    let msgs = ''
    let errors = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Error]])')
    let warnings = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Warning]])')
    let infos = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Information]])')
    let hints = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Hint]])')
    if errors > 0 | let msgs .= " \uf057 " . errors | endif
    if warnings > 0 | let msgs .= " \uf06a " . warnings | endif
    if infos > 0 | let msgs .= " \uf059 " . infos | endif
    if hints > 0 | let msgs .=  " \uf055 " . hints | endif
    if !empty(msgs) && winwidth(0) > 80 | let statusline .= msgs . ' | '| endif
    " Buffer properties
    if &readonly && &modifiable | let statusline .= "\uf05e Read-only | " | endif
    if &modified && &modifiable | let statusline .= "\uf44d " | endif
    if !empty(expand('%')) | let statusline .= fnamemodify(expand('%'),':~:.') . ' | ' | endif
    let statusline .= "\ufc92 " . col('.') .  " \uf1dd " . line('.') . ' '
    return statusline
endfunction

function! _SpecialStatusline() abort
    " Used when &buftype is set
    if &buftype == 'terminal' | return "\uf44f Terminal " | endif
    if &buftype == 'help' | return "\uf7d6 Help - ".expand('%:t') . ' ' | endif
    if &buftype == 'quickfix' | return "\uf4a0  Quickfix - " . w:quickfix_title . ' ' | endif
    if &filetype == 'peekaboo' | return "\uf64d" | endif
    if &filetype == 'vim-plug' | return "\uf1e6  Plugins" | endif
    if &filetype == 'diff' | return t:diffpanel.GetStatusLine() | endif
    if &filetype == 'undotree'
        let status = t:undotree.GetStatusLine()
        let status = substitute(status, 'current:', 'Current:', '')
        let status = substitute(status, 'redo:', "\uf0e2", '')
        return status
    endif
    return ''
endfunction

function! _Tabline() abort
    let tabline = ''
    for i in range(tabpagenr('$'))
        if i+1 == tabpagenr()
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif
        let buflist = tabpagebuflist(i+1)
        let winnr = tabpagewinnr(i+1)
        let name = fnamemodify(bufname(buflist[winnr-1]), ':t')
        if empty(name) | let name = '-- Empty --' | endif
        let tabline .= '%' . (i+1) . 'T ' . name . ' '
    endfor
    return tabline . '%#TabLineFill#'
endfunction

function! _TitleString() abort
    let icon = "\ue62b "
    " Special buffers
    if &filetype == 'vim-plug' | return icon . 'Plugins' | endif
    if &filetype == 'undotree' | return icon . 'Undotree' | endif
    if &filetype == 'peekaboo' | return icon . 'Registers' | endif
    if &filetype ==  'diff' | return icon . 'Diff panel' | endif
    if &buftype == 'quickfix' | return icon . 'Quickfix' | endif
    if &buftype == 'help' | return icon . 'Help' | endif
    if &buftype == 'terminal' | return icon . 'Terminal' | endif
    " Regular buffer
    return icon . substitute(getcwd(),$HOME,'~','') . "\uf460" . fnamemodify(expand('%'),':~:.')
endfunction

function! s:highlight_group()
    let msg = 'Highlight: '
    let symbol = synID(line('.'), col('.'), 1)
    let name = synIDattr(symbol, 'name')
    let link = synIDattr(synIDtrans(symbol), 'name')
    if name == link
        return msg . name
    endif
    return msg . name . " \ufc32 " . link
endfunction

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
        if !empty(&equalprg) && &equalprg != &formatprg
            silent! normal! gg=G
            if empty(msg) | let msg .= 'Reindented. ' | endif
        endif
    endif
    let last_search = @/
    silent! %substitute/\s\+$//e
    let @/ = last_search
    nohlsearch
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

" AUTOCMDS
" --------
augroup init_dot_vim
autocmd!
autocmd TermOpen * startinsert
autocmd TermOpen,FileType * if !empty(&buftype)
    \ | setlocal statusline=%=%{_SpecialStatusline()}%=
    \ | endif
autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
autocmd VimResized * if exists('#goyo') | execute "normal \<C-W>=" | endif
autocmd ColorScheme * highlight ModeMsg cterm=bold gui=bold ctermfg=7 guifg=#ECEEF4
    \ | highlight TabLineFill ctermbg=None guibg=None
    \ | highlight TabLineSel cterm=bold gui=bold ctermfg=7 guifg=#D8DEE9
    \ | highlight StatusLine cterm=bold gui=bold ctermbg=None ctermfg=7 guibg=None guifg=#ECEEF4
    \ | highlight StatusLineNC ctermbg=None guibg=None ctermfg=8 guifg=#4C566A
    \ | highlight link LspDiagnosticsDefaultError LSPDiagnosticsError
    \ | highlight link LspDiagnosticsDefaultWarning LSPDiagnosticsWarning
    \ | highlight link LspDiagnosticsDefaultInformation LSPDiagnosticsInformation
    \ | highlight link LspDiagnosticsDefaultHint LSPDiagnosticsHint
augroup END

" COLORSCHEME
" -----------
colorscheme nord
set termguicolors
