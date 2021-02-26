" --------------------
" NEOVIM EDITOR CONFIG
" --------------------

if !filereadable(stdpath('data').'/site/autoload/plug.vim') " Auto-install vim-plug
    silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
let g:polyglot_disabled = ['ftdetect']

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
set expandtab   softtabstop=4   shiftwidth=4    shiftround
set noruler     nowrap          updatetime=500  shortmess+=cI
set path=.,**   ignorecase      smartcase       mouse+=ar
set hidden      undofile        undolevels=500  autowrite
set cursorline  conceallevel=2  concealcursor=
set nonumber    signcolumn=yes  norelativenumber
set splitbelow  splitright      switchbuf=usetab
set scrolloff=1 sidescrolloff=4 virtualedit=block
set sps+=5      spl=pl,en_us    clipboard+=unnamedplus
set title       titlelen=0      titlestring=%{_TitleString()}
set ph=20       completeopt=menuone,noinsert,noselect
set list        listchars=tab:>-,trail:·,extends:>,precedes:<
set tabline=%!_Tabline()        statusline=%!_Statusline()

" Spellfile
if !isdirectory(stdpath('data').'/site/spell')
    exec '!mkdir '.stdpath('data').'/site/spell'
endif
let &spellfile = stdpath('data').'/site/spell/utf-8.add'

" Disable netrw
" Note: comment this if you want to to download spellfiles
let g:loaded_netrwPlugin = 1

" Completion configuration
let g:completion_matching_smart_case = 1
let g:completion_matching_strategy_list = ['exact', 'substring']
let g:completion_timer_cycle = 100
let g:completion_enable_auto_hover = 1
let g:completion_menu_length = 80
let g:completion_mennu_abbr = 80

" Undo tree configuration
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2
let g:undotree_HelpLine = 0
let g:undotree_ShortIndicators = 1
let g:undotree_CursorLine = 1
let g:undotree_DiffpanelHeight = 6

" Indent line configuration
let g:indentLine_color_term = 8
let g:indentLine_color_gui = '#4C566A'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_char = "\u00a6"
let g:indentLine_first_char = "\u00a6"
let g:indentLine_setConceal = 0
let g:indentLine_bufTypeExclude = ['help', 'terminal', 'nofile', 'nowrite']

"Theme configuration
let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_underline = 1

call sign_define('LspDiagnosticsSignError', {'text':"\uf057", 'texthl':'LspDiagnosticsDefaultError'})
call sign_define('LspDiagnosticsSignWarning', {'text':"\uf06a", 'texthl':'LspDiagnosticsDefaultWarning'})
call sign_define('LspDiagnosticsSignInformation', {'text':"\uf059", 'texthl':'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsSignHint', {'text' : "\uf055", 'texthl':'LspDiagnosticsDefaultHint'})

" MAPS
" ----
let g:mapleader = "\<Space>"

nnoremap Y y$
nnoremap Q @q
noremap <Del> "_
nnoremap <C-j> a<CR><ESC>
nnoremap [<Space> O<ESC>
nnoremap ]<Space> o<ESC>
nnoremap <S-Tab> <C-o>
noremap = <CMD>call <SID>format_buffer()<CR>
nnoremap ZZ <CMD>update<Bar>bdelete!<CR>
nnoremap <C-l> <CMD>noh<Bar>call <SID>wipe_empty()<CR><C-l>
tnoremap <C-w> <C-\><C-n>

nnoremap <leader>b <CMD>mode<Bar>buffers<CR>:b<Space>
nnoremap <leader>f :find<Space>
nnoremap gb <CMD>bnext<CR>
nnoremap gB <CMD>bprev<CR>

nnoremap <leader>c <CMD>call <SID>toggle_conceal()<CR>
nnoremap <leader>l <CMD>call <SID>toggle_colorcolumn()<CR>
nnoremap <leader>s <CMD>call <SID>toggle_spell()<CR>
nnoremap <leader>w <CMD>call <SID>toggle_wrap()<CR>
nnoremap <leader>h <CMD>mode<Bar>exec 'highlight '.synIDattr(synID(line('.'), col('.'), 1), 'name')<CR>

nnoremap <leader>g <CMD>Goyo<CR>
nnoremap <leader>u <CMD>UndotreeToggle<CR>
nnoremap <leader>t <CMD>sp<CR><CMD>term<CR><C-\><C-n><C-w>10_i

" Insert mode completion
inoremap <expr> <C-Space> pumvisible() ? "\<C-e>" : "\<C-n>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Location and quickfix lists
nnoremap [l <CMD>lprev<CR>
nnoremap ]l <CMD>lnext<CR>
nnoremap gl <CMD>lopen<CR>
nnoremap [q <CMD>cprev<CR>
nnoremap ]q <CMD>cnext<CR>
noremap gq <CMD>copen<CR>

" Replace word under cursor
nmap <C-n> <leader>r
nnoremap <leader>r :%s/<C-r>=expand('<cword>')<CR>//gc<Left><Left><Left>

" Disable middle mouse click
noremap <MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>
cnoremap <MiddleMouse> <Nop>

" FUNCTIONS
" ---------
function! _LSPDiagnostics() abort
    let msgs = ''
    let errors = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Error]])')
    let warnings = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Warning]])')
    let infos = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Information]])')
    let hints = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Hint]])')
    if errors > 0 | let msgs .= " \uf057 " . errors | endif
    if warnings > 0 | let msgs .= " \uf06a " . warnings | endif
    if infos > 0 | let msgs .= " \uf059 " . infos | endif
    if hints > 0 | let msgs .=  " \uf055 " . hints | endif
    if !empty(msgs) && winwidth(0) > 80 | return trim(msgs) | endif
    return ''
endfunction

function! _Statusline() abort
    let statusline = '%=%{_LSPDiagnostics()} '
    let statusline .= '%{&readonly && &modifiable ? "\uf05e Read-only " : ""}%{&modified && &modifiable ? "\uf44d " : ""}'
    let statusline .= '[%1*%{g:actual_curwin == win_getid() && !empty(expand("%")) ? fnamemodify(expand("%"),":~:.") . " " : ""}%*'
    let statusline .= '%{g:actual_curwin != win_getid() && !empty(expand("%")) ? fnamemodify(expand("%"),":~:.") . " " : ""}'
    let statusline .= '%2*%{g:actual_curwin == win_getid() ? "\ufc92 " : ""}%*%{g:actual_curwin != win_getid() ? "\ufc92 " : ""}%{col(".")} '
    let statusline .= '%3*%{g:actual_curwin == win_getid() ? "\uf1dd " : ""}%*%{g:actual_curwin != win_getid() ? "\uf1dd " : ""}%*%l] %<'
    return statusline
endfunction

function! _SpecialStatusline() abort
    " Used when &buftype is set
    if &filetype == 'terminal' | return "\uf44f Terminal"
    elseif &filetype == 'help' | return "\uf7d6 Help - " . expand('%:t')
    elseif &filetype == 'man' | return "\uf7d6 Man - " . expand('%:t')
    elseif &filetype == 'peekaboo' | return "\uf64d Registers"
    elseif &filetype == 'cmdwin' | return "\uf155 Commands"
    elseif &filetype == 'vim-plug' | return "\uf1e6  Plugins"
    elseif &filetype == 'diff' | return t:diffpanel.GetStatusLine()
    elseif &filetype == 'undotree'
        let status = t:undotree.GetStatusLine()
        let status = substitute(status, 'current:', 'Current:', '')
        let status = substitute(status, 'redo:', "\uf0e2", '')
        return status
    elseif &filetype == 'qf'
        if exists('w:quickfix_title')
            return "\uf4a0  Quickfix - " . w:quickfix_title
        else
            return "\uf4a0  Quickfix"
        endif
    else | return '' | endif
endfunction

function! _Tabline() abort
    let tabline = ''
    for i in range(tabpagenr('$'))
        if i+1 == tabpagenr()
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif
        let buf = tabpagebuflist(i+1)[tabpagewinnr(i+1)-1]
        let name = ''
        let filetype = getbufvar(buf, '&filetype')
        if filetype == 'vim-plug' | let name = 'Plugins'
        elseif filetype == 'undotree' | let name = 'Undotree'
        elseif filetype == 'peekaboo' | let name = 'Registers'
        elseif filetype == 'man' | let name = 'Man'
        elseif filetype == 'diff' | let name = 'Diff panel'
        elseif filetype == 'qf' | let name = 'Quickfix'
        elseif filetype == 'help' | let name = 'Help'
        elseif filetype == 'terminal' | let name = 'Terminal'
        elseif filetype == 'cmdwin' | let name = 'Commands'
        else | let name = fnamemodify(bufname(buf), ':t') | endif
        if empty(name) | let name = 'No name' | endif
        let tabline .= '%' . (i+1) . 'T ' . name . ' '
    endfor
    return tabline . '%#TabLineFill#'
endfunction

function! _TitleString() abort
    let start = "\ue62b ". substitute(getcwd(),$HOME,'~','') . "\uf460"
    if &filetype == 'vim-plug' | return start . 'Plugins'
    elseif &filetype == 'undotree' | return start . 'Undotree'
    elseif &filetype == 'peekaboo' | return start . 'Registers'
    elseif &filetype == 'man' | return start . 'Man - ' . expand('%:t')
    elseif &filetype ==  'diff' | return start . 'Diff panel'
    elseif &filetype == 'qf' | return start . 'Quickfix'
    elseif &filetype == 'help' | return start . "Help - " . expand('%:t')
    elseif &filetype == 'terminal' | return start . 'Terminal'
    elseif &filetype == 'cmdwin' | return start . 'Commands'
    else | return start . fnamemodify(expand('%'),':~:.') | endif
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
            silent! keepjumps normal! gggqG
            let msg .= 'Formatted buffer. '
        endif
        if !empty(&equalprg) && &equalprg != &formatprg
            silent! keepjumps normal! gg=G
            if empty(msg) | let msg .= 'Reindented. ' | endif
        endif
    endif
    let last_search = @/
    silent! keepjumps %substitute/\s\+$//e
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

function! s:toggle_conceal() abort
    if &l:conceallevel != 0 | setlocal conceallevel=0 | echo 'Conceal disabled'
    else | setlocal conceallevel=2 | echo 'Conceal enabled' | endif
endfunction

function! s:toggle_colorcolumn() abort
    if &l:colorcolumn != '' | setlocal colorcolumn= | echo 'Colorcolumn disabled'
    else
        if &l:textwidth | setlocal colorcolumn=+1
        else | setlocal colorcolumn=81 | endif
        echo 'Colorcolumn enabled'
    endif
endfunction

function! s:toggle_wrap() abort
    if &l:wrap | setlocal nowrap | echo 'Line wrapping disabled'
    else | setlocal wrap | echo 'Line wrapping enabled' | endif
endfunction

function! s:toggle_spell() abort
    if &l:spell | setlocal nospell | echo 'Spellcheck disabled'
    else | setlocal spell | echo 'Spellcheck enabled' | endif
endfunction

" AUTOCMDS
" --------
augroup init_dot_vim
autocmd!
autocmd TermOpen * setfiletype terminal | startinsert
autocmd CmdWinEnter * setfiletype cmdwin
autocmd FileType * if !empty(&buftype)
    \ | setlocal statusline=%=%{_SpecialStatusline()}%=
    \ | endif
autocmd FileType qf execute "normal 6\<C-w>_"
autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
autocmd VimResized * if exists('#goyo') | execute "normal \<C-W>=" | endif
autocmd ColorScheme * highlight ModeMsg cterm=bold gui=bold ctermfg=7 guifg=#ECEEF4
    \ | highlight TabLineFill ctermbg=None guibg=None
    \ | highlight TabLineSel cterm=bold gui=bold ctermfg=7 guifg=#D8DEE9
    \ | highlight StatusLine cterm=bold gui=bold ctermbg=None ctermfg=7 guibg=None guifg=#ECEEF4
    \ | highlight User1 cterm=bold gui=bold ctermbg=None ctermfg=6 guibg=None guifg=#81A1C1
    \ | highlight User2 cterm=bold gui=bold ctermbg=None ctermfg=4 guibg=None guifg=#88C0D0
    \ | highlight User3 cterm=bold gui=bold ctermbg=None ctermfg=2 guibg=None guifg=#A3BE8C
    \ | highlight StatusLineNC cterm=bold gui=bold ctermbg=None guibg=None ctermfg=8 guifg=#4C566A
    \ | highlight link LspDiagnosticsDefaultError LSPDiagnosticsError
    \ | highlight link LspDiagnosticsDefaultWarning LSPDiagnosticsWarning
    \ | highlight link LspDiagnosticsDefaultInformation LSPDiagnosticsInformation
    \ | highlight link LspDiagnosticsDefaultHint LSPDiagnosticsHint
autocmd TextYankPost * silent! lua vim.highlight.on_yank{on_visual=false, higroup="MatchParen", timeout=350}
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | endif
augroup END

" COLORSCHEME
" -----------
colorscheme nord
set termguicolors
