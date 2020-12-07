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
Plug 'tpope/vim-surround' " Change surrounding braces/quotes
Plug 'jiangmiao/auto-pairs' " Auto pairs for '(' '[' '{' and surroundings
Plug 'tpope/vim-commentary' " Comment automation
Plug 'tpope/vim-repeat' " Repeat surroundings/commentary with '.'
Plug 'arcticicestudio/nord-vim' " Theme
Plug 'itchyny/lightline.vim' " Status bar
Plug 'Yggdroot/indentLine' " Indentation line indicators
Plug 'junegunn/goyo.vim' " Distraction-free mode
Plug 'neovim/nvim-lspconfig' " Native LSP client implementation
Plug 'nvim-lua/completion-nvim' " Native LSP completion window
call plug#end()

" SETTINGS
" --------
set tabstop=4   softtabstop=4   shiftwidth=4    expandtab   shiftround
set nowrap      scrolloff=4     cursorline      sidescrolloff=8
set number      relativenumber  numberwidth=3   signcolumn=number
set noshowmode  updatetime=300  confirm         shortmess+=c
set hidden      conceallevel=2  concealcursor=
set splitbelow  splitright      switchbuf=usetab
set list        listchars=tab:-,trail:·
set title       titlestring=%{'\ '.substitute(getcwd(),$HOME,'~','').'\ \ '.fnamemodify(expand('%'),':~:.')}
set undofile    undolevels=500  autowrite
set mouse+=ar   virtualedit=block
set path=**,.,, completeopt=menuone,noinsert,noselect

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
let g:undotree_DiffpanelHeight = 6
let g:undotree_Splitwidth = 10

let g:completion_enable_auto_signature = 1
let g:completion_matching_ignore_case = 1
let g:completion_enable_auto_hover = 0
let g:completion_enable_auto_paren = 1

"Theme configuration
let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_underline = 1
colorscheme nord

" Statusline configuration
let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'active': {
    \ 'left': [ ['mode'], ['filename'], ['readonly', 'modified'] ],
    \ 'right': [['filetype', 'lineinfo'], [], ['diagnostics', 'gitbranch'] ]
    \ },
    \ 'inactive': {
    \ 'left': [['filename'], ['readonly', 'modified'] ], 'right': []
    \ },
    \ 'component': {
    \ 'readonly' : '%{&readonly && &modifiable ? " Read-only" :  ""}',
    \ 'modified' : '%{&modified && &modifiable ? " " : ""}',
    \ 'filetype' : '%{strlen(&filetype) ? " ".&filetype : " ---"}%<',
    \ 'lineinfo' : '%{"ﲒ ".virtcol(".")."  ".line(".").":".line("$")}%<'
    \ },
    \ 'component_function' : {
    \ 'gitbranch' : 'LightlineGitbranch',
    \ 'diagnostics' : 'LightlineDiagnostics'
    \ }
    \ }

" Indentline configuration
let g:indentLine_color_term = 0
let g:indentLine_char = '|'
let g:indentLine_setConceal = 0

" LSP diagnostics highlighting
sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsDefaultError linehl= numhl=
sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsDefaultWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsDefaultHint linehl= numhl=

highlight link LspDiagnosticsDefaultError LSPDiagnosticsError
highlight link LspDiagnosticsDefaultWarning LSPDiagnosticsWarning
highlight link LspDiagnosticsDefaultInformation LSPDiagnosticsInformation
highlight link LspDiagnosticsDefaultHint LSPDiagnosticsHint

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
nnoremap <silent><expr> ZB &modified ? ':w\|bd<CR>' : ':bd!<CR>'
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
            \ "<cmd>lua vim.lsp.buf.hover()<CR>" : "\K"
nnoremap <expr> <leader>r luaeval('vim.lsp.buf.server_ready()') ?
            \ "<cmd>lua vim.lsp.buf.rename()<CR>" : "#"
nnoremap <expr> [d luaeval('vim.lsp.buf.server_ready()') ?
            \ "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>" : "\[d"
nnoremap <expr> ]d luaeval('vim.lsp.buf.server_ready()') ?
            \ "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>" : "\]d"
nnoremap <expr> <C-]> luaeval('vim.lsp.buf.server_ready()') ?
            \ "<cmd>lua vim.lsp.buf.definition()<CR>" : "\<C-]>"
nnoremap <expr> <C-t> luaeval('vim.lsp.buf.server_ready()') ?
            \ "<cmd>lua vim.lsp.buf.references()<CR>" : "\<C-t>"

" Disable middle mouse click
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>

" Other maps
nnoremap <C-u> <cmd>UndotreeToggle<CR>
nnoremap - <cmd>Explore<CR>
tnoremap <C-\> <C-\><C-n>
nnoremap <leader>g <cmd>Goyo<CR>
nnoremap <leader>n <cmd>nohlsearch<CR>
let g:AutoPairsShortcutToggle = "\<C-p>"

" COMMANDS
" --------
command! -nargs=0 Format call <SID>format_file()
command! -nargs=0 Diagnostic call <SID>display_diagnostics()

" LSP
" ---
lua require('lspconf')

" FUNCTIONS
" ---------
function! s:format_file() abort
    if !luaeval('vim.lsp.buf.server_ready()')
        let last_search = @/
        silent! %substitute/\s\+$//e
        let @/ = last_search
        nohlsearch
        unlet last_search
        echo 'Stripped trailing whitespace.'
    else
        lua vim.lsp.buf.formatting_sync(nil, 1000)
        echo 'Formatted buffer.'
    endif
endfunction

function! s:display_diagnostics() abort
    if !luaeval('vim.lsp.buf.server_ready()')
       lwindow
    else
        lua vim.lsp.diagnostic.set_loclist()
    endif
endfunction

function! s:set_git_branch() abort
    if empty(expand("%:h")) | return | endif
    let git_output = trim(system('git -C ' . expand("%:h") . ' branch --show-current'))
    if stridx(git_output, 'fatal: not a git repository')!=-1
        return
    endif
    let b:current_branch_name = git_output
endfunction

function! LightlineDiagnostics() abort
    let msgs = ''
    if winwidth(0) < 70 | return msgs | endif
    let errors = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Error]])')
    let warnings = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Warning]])')
    let infos = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Information]])')
    let hints = luaeval('vim.lsp.diagnostic.get_count(vim.fn.bufnr("%"), [[Hint]])')
    if errors > 0
        let msgs .= ' ' . errors
    endif
    if warnings > 0
        if !empty(msgs) | let msgs .= ' ' | endif
        let msgs .= ' ' . warnings
    endif
    if infos > 0
        if !empty(msgs) | let msgs .= ' ' | endif
        let msgs .= ' ' . infos
    endif
    if hints > 0
        if !empty(msgs) | let msgs .= ' ' | endif
        let msgs .= ' ' . hints
    endif
    return msgs
endfunction

function! LightlineGitbranch() abort
    if exists('b:current_branch_name') && winwidth(0) > 70
        return ' ' . b:current_branch_name
    endif
    return ''
endfunction

" AUTOCMDS
" --------
augroup user_created
    autocmd!
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
    autocmd BufEnter * call <SID>set_git_branch()
augroup END
