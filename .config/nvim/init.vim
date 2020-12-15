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
Plug 'tpope/vim-surround' " Change surrounding brackets/quotes
Plug 'jiangmiao/auto-pairs' " Auto pairs for brackets/quotes
Plug 'tpope/vim-commentary' " Comment automation
Plug 'tpope/vim-repeat' " Repeat surroundings/commentary with '.'
Plug 'sheerun/vim-polyglot' " Multi-language pack
Plug 'arcticicestudio/nord-vim' " Theme
Plug 'Yggdroot/indentLine' " Indentation line indicators
Plug 'junegunn/goyo.vim' " Distraction-free mode
Plug 'neovim/nvim-lspconfig' " Native LSP client implementation
Plug 'nvim-lua/completion-nvim' " Native LSP completion window
call plug#end()

" SETTINGS
" --------
set tabstop=4   softtabstop=4   shiftwidth=4    expandtab   shiftround
set confirm     updatetime=500  shortmess+=c    virtualedit=block
set nowrap      cursorline      scrolloff=4     sidescrolloff=6
set undofile    undolevels=500  autowrite       signcolumn=yes
set hidden      conceallevel=2  concealcursor=  mouse+=ar
set list        fcs=eob:\       listchars=tab:>-,trail:·
set path=**,.,, completeopt=menuone,noinsert,noselect
set splitbelow  splitright      switchbuf=usetab

" Title
set title titlelen=0
set titlestring=
set titlestring+=%{\"\\ue62b\ \".substitute(getcwd(),$HOME,'~','')}
set titlestring+=%{\"\\uf460\".fnamemodify(expand('%'),':~:.')}

" Statusline
set statusline=
set statusline+=%#StatusLineNC#
set statusline+=%=%1*%{StatuslineDiagnostics()}%*
set statusline+=\ %{&readonly\ &&\ &modifiable\ ?\ \"\\uf05e\ Read-only\ \|\ \"\ :\ ''}
set statusline+=%{&modified\ &&\ &modifiable\ ?\ \"\\uf44d\ \"\ :\ ''}
set statusline+=%{fnamemodify(expand('%'),':~:.')}\ \|\ %{\"\\ufc92\"}\ %c
set statusline+=\ %{\"\\uf1dd\"}\ %l\ %{\"\\uf719\"}\ %n\ %<

" Python executable
let g:python3_host_prog='/usr/bin/python3'

" Netrw configuration
let g:netrw_browse_split = 0
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_altv = 1
let g:netrw_home = stdpath('cache')
let g:netrw_localrmdir='rm -r'

" Undoo tree configuration
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2
let g:undotree_HelpLine = 0
let g:undotree_ShortIndicators = 1
let g:undotree_CursorLine = 1
let g:undotree_DiffpanelHeight = 5
let g:undotree_Splitwidth = 10

" Completion popup configuration
let g:completion_enable_auto_signature = 1
let g:completion_matching_ignore_case = 1
let g:completion_enable_auto_hover = 0
let g:completion_enable_auto_paren = 1

" Indentline configuration
let g:indentLine_color_term = 8
let g:indentLine_char = "\u2506"
let g:indentLine_setConceal = 0
let g:indentLine_bufTypeExclude = ['help', 'term']

" LSP diagnostics highlighting
call sign_define('LspDiagnosticsSignError', {'text':"\uf057", 'texthl':'LspDiagnosticsDefaultError'})
call sign_define('LspDiagnosticsSignWarning', {'text':"\uf06a", 'texthl':'LspDiagnosticsDefaultWarning'})
call sign_define('LspDiagnosticsSignInformation', {'text':"\uf059", 'texthl':'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsSignHint', {'text' : "\uf055", 'texthl':'LspDiagnosticsDefaultHint'})

"Theme configuration
let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_underline = 1

" CLIPBOARD
" ---------
let g:clipboard = {
  \   'name': 'xclip',
  \   'copy': {'+': 'xclip -selection clipboard', '*': 'xclip -selection clipboard'},
  \   'paste': {'+': 'xclip -selection clipboard -o', '*': 'xclip -selection clipboard -o'},
  \   'cache_enabled': 1,
  \ }
set clipboard+=unnamedplus

" MAPS
" ----
let g:mapleader = " "

" Buffer management
nnoremap <silent><expr> ZZ &modified ? ':w\|bd<CR>' : ':bd!<CR>'
nnoremap <silent> gb :bnext<CR>
nnoremap <silent> gB :bprev<CR>

" Use the leader key to cut into black hole register
nnoremap <leader>x "_x
nnoremap <leader>X "_X
nnoremap <leader>s "_s
nnoremap <leader>S "_S
nnoremap <leader>d "_d
nnoremap <leader>D "_D

vnoremap <leader>x "_x
vnoremap <leader>X "_X
vnoremap <leader>s "_s
vnoremap <leader>S "_S
vnoremap <leader>d "_d
vnoremap <leader>D "_D

" Line splitting from normal mode
nnoremap <silent> [<CR> O<ESC>
nnoremap <silent> ]<CR> o<ESC>
nnoremap <silent> K a<CR><ESC>

" Insert mode completion
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr> <C-n> pumvisible() ? "\<C-e>" : "\<C-n>"

" LSP completion
imap <expr> <C-space> pumvisible() ?
            \ "\<C-e>" : luaeval('vim.lsp.buf.server_ready()') ? "<Plug>(completion_trigger)" : "\<C-n>"
let g:completion_confirm_key = "\<CR>"

" LSP code actions
nnoremap <expr> <C-h> luaeval('vim.lsp.buf.server_ready()') ?
            \ "<CMD>lua vim.lsp.buf.hover()<CR>" : "\K"
nnoremap <expr> <leader>r luaeval('vim.lsp.buf.server_ready()') ?
            \ "<CMD>lua vim.lsp.buf.rename()<CR>" : "#"
nnoremap <expr> [d luaeval('vim.lsp.buf.server_ready()') ?
            \ "<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>" : "\[d"
nnoremap <expr> ]d luaeval('vim.lsp.buf.server_ready()') ?
            \ "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>" : "\]d"
nnoremap <expr> <C-]> luaeval('vim.lsp.buf.server_ready()') ?
            \ "<CMD>lua vim.lsp.buf.definition()<CR>" : "\<C-]>"
nnoremap <expr> <C-t> luaeval('vim.lsp.buf.server_ready()') ?
            \ "<CMD>lua vim.lsp.buf.references()<CR>" : "\<C-t>"

" Disable middle mouse click
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>

" Other maps
nnoremap <C-u> <CMD>UndotreeToggle<CR>
nnoremap - <CMD>Explore<CR>
tnoremap <C-\> <C-\><C-n>
nnoremap <leader>g <CMD>Goyo<CR>
nnoremap <leader>n <CMD>nohlsearch<CR>
let g:AutoPairsShortcutToggle = "\<C-p>"

" COMMANDS
" --------
command! -nargs=0 Format call <SID>format_file()
command! -nargs=0 Diagnostic call <SID>display_diagnostics()

" LUA
" ---
lua require('lspconf')

" FUNCTIONS
" ---------
function! s:format_file() abort
    let msg = ''
    if luaeval('vim.lsp.buf.server_ready()')
        lua vim.lsp.buf.formatting()
        let msg .= 'Formatted buffer. '
    endif
    let last_search = @/
    silent! %substitute/\s\+$//e
    let @/ = last_search
    nohlsearch
    unlet last_search
    let msg .= 'Stripped trailing whitespace.'
    echo msg
endfunction

function! s:display_diagnostics() abort
    if !luaeval('vim.lsp.buf.server_ready()')
       lwindow
    else
        lua vim.lsp.diagnostic.set_loclist()
    endif
endfunction

function! StatuslineDiagnostics() abort
    let msgs = ''
    if winwidth(0) < 70 | return msgs | endif
    let errors = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Error]])')
    let warnings = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Warning]])')
    let infos = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Information]])')
    let hints = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Hint]])')
    if errors > 0
        let msgs .= "\uf057 " . errors
    endif
    if warnings > 0
        if !empty(msgs) | let msgs .= ' ' | endif
        let msgs .= "\uf06a " . warnings
    endif
    if infos > 0
        if !empty(msgs) | let msgs .= ' ' | endif
        let msgs .= "\uf059 " . infos
    endif
    if hints > 0
        if !empty(msgs) | let msgs .= ' ' | endif
        let msgs .=  "\uf055 " . hints
    endif
    if !empty(msgs) | return msgs .' '| endif
    return ''
endfunction

" AUTOCMDS
" --------
augroup init_vim
    autocmd!
    autocmd TermOpen * startinsert
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd FileType qf setlocal statusline=
    autocmd VimResized * if exists('#goyo') | execute "normal \<C-W>=" | endif
    autocmd ColorScheme * highlight User1 ctermbg=None ctermfg=7
        \ | highlight link LspDiagnosticsDefaultError LSPDiagnosticsError
        \ | highlight link LspDiagnosticsDefaultWarning LSPDiagnosticsWarning
        \ | highlight link LspDiagnosticsDefaultInformation LSPDiagnosticsInformation
        \ | highlight link LspDiagnosticsDefaultHint LSPDiagnosticsHint
        \ | highlight StatusLine ctermbg=8 ctermfg=7
        \ | highlight StatusLineNC ctermbg=None ctermfg=8
        \ | highlight TabLineFill ctermbg=None
        \ | highlight TabLineSel ctermfg=7
        \ | highlight ModeMsg cterm=bold ctermfg=7
        \ | highlight link MsgSeparator StatusLineNC
augroup END

" COLORSCHEME
" -----------
colorscheme nord
