" -----------------------------
" NEOVIM TERMINAL EDITOR CONFIG
" -----------------------------

" PLUGINS
" -------

if !filereadable(stdpath('data').'/site/autoload/plug.vim') " Auto-install vim-plug
    silent !curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin(stdpath('data').'/vim-plug')
" Quality of life plugins
Plug 'mbbill/undotree' " Undo tree visualized
Plug 'junegunn/vim-peekaboo' " Registers visualized
Plug 'jiangmiao/auto-pairs' " Auto pairs for '(' '[' '{' and surroundings
Plug 'tpope/vim-surround' " Change surrounding braces/quotes
Plug 'tpope/vim-commentary' " Comment automation
Plug 'tpope/vim-repeat' " Repeat surroundings/commentary with '.'
Plug 'sheerun/vim-polyglot' " Multi-language pack
" Visual enchancments
Plug 'arcticicestudio/nord-vim' " Theme
Plug 'itchyny/lightline.vim' " Status bar
Plug 'Yggdroot/indentLine' " Indentation line indicators
Plug 'junegunn/goyo.vim' " Distraction-free mode
" Optional LSP functionality
" exec 'source'.stdpath('config').'/lsp.vim'
call plug#end()

" MAPS
" ----

let g:mapleader = " "

" Buffer management
nnoremap <silent><expr> ZB &modified ? ':w\|bd<CR>' : ':bd!<CR>'
nnoremap <silent> gb :bnext<CR>
nnoremap <silent> gB :bprev<CR>

" Use the leader key to cut into black hole register
nnoremap <leader>x "_x
nnoremap <leader>s "_s
nnoremap <leader>d "_d
nnoremap <leader>D "_D
vnoremap <leader>x "_x
vnoremap <leader>s "_s
vnoremap <leader>d "_d

" Line splitting from normal mode
nnoremap <silent> [<CR> O<ESC>
nnoremap <silent> ]<CR> o<ESC>
nnoremap <silent> K a<CR><ESC>

" Disable middle mouse click
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>

" Other shortcuts
nnoremap <silent> <C-u> :UndotreeToggle<CR>
nnoremap <silent><nowait> - :Explore<CR>
tnoremap <C-space> <C-\><C-n>
let g:AutoPairsShortcutToggle = "\<C-p>"

" SETTINGS
" --------

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab shiftround
set nowrap scrolloff=4 sidescrolloff=8
set number numberwidth=3 signcolumn=number
set splitbelow splitright
set noshowmode laststatus=2 title
set conceallevel=2 concealcursor=inc shortmess+=c hidden
set updatetime=300 switchbuf=usetab
set undofile nobackup autowrite nowritebackup
set list listchars=tab:-,trail:░
set mouse+=ar

" Netrw configuration
let g:netrw_browse_split = 0
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_altv = 1
let g:home = $HOME
let g:netrw_home = $HOME.'/.cache/nvim'
let g:netrw_localrmdir='rm -r'

" Undoo tree configuration
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2
let g:undotree_HelpLine = 0
let g:undotree_ShortIndicators = 1
let g:undotree_CursorLine = 1
let g:undotree_DiffpanelHeight = 6
let g:undotree_Splitwidth = 10

" Language pack configuration
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" THEME
" -----

let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord

let g:lightline = {
        \ 'colorscheme': 'nord',
        \ 'active': {
        \       'left': [ ['mode'], ['filename'], ['readonly', 'modified'] ],
        \       'right': [ ['filetype', 'lineinfo'] ]
        \ },
        \ 'inactive': {
        \       'left': [ [ 'filename' ] ], 'right': [ [ 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'filetype': 'LightlineFiletype',
        \   'lineinfo': 'LightlineLineinfo',
        \   'filename': 'LightlineFilename',
        \   'readonly': 'LightlineReadonly',
        \   'modified': 'LightlineModified'
        \ },
        \ }

let g:indentLine_color_term = 0
let g:indentLine_char = '|'
let g:indentLine_setConceal = 0

" CLIPBOARD
" ---------

let g:clipboard = {
  \   'name': 'xclip',
  \   'copy': {'+': 'xclip -selection clipboard', '*': 'xclip -selection clipboard'},
  \   'paste': {'+': 'xclip -selection clipboard -o', '*': 'xclip -selection clipboard -o'},
  \   'cache_enabled': 1,
  \ }
set clipboard+=unnamedplus

" FUNCTIONS
" ---------

function! s:bad_buffer() abort
    " Disable lightline elements for certain buffer types
    let names = [ "undotree", "diff", "netrw", "vim-plug" ]
    for str in names | if stridx(&filetype, str)!=-1 | return 1 | endif | endfor
    return 0
endfunction

function! s:get_title_string() abort
    return " ". substitute(getcwd(), g:home, "~", "")."  ".fnamemodify(expand("%"), ":~:.")
endfunction

function! s:netrw_mappings() abort
    nmap <buffer> l <CR>
    nmap <buffer> L gn
    nmap <buffer> h <Plug>NetrwBrowseUpDir()
    noremap <silent><buffer> - :bd!<CR>
    setlocal eventignore+=CursorHold
endfunction

" Lightline elements
function! LightlineFiletype() abort
    return strlen(&filetype) ? ' '.&filetype : ''
endfunction
function! LightlineFilename() abort
    return <SID>bad_buffer() ? "" : expand("%:t")
endfunction
function! LightlineLineinfo() abort
    return <SID>bad_buffer() || winwidth(0) < 35 ? '' : 'ﲒ '.virtcol('.').'  '.line('.').':'.line('$') 
endfunction
function! LightlineReadonly() abort
    return &readonly && !<SID>bad_buffer() ? " Read-only" :  ""
endfunction
function! LightlineModified() abort
    return &modified && !<SID>bad_buffer() ? " " : ""
endfunction

" AUTOCMDS
" --------

augroup user_created
    autocmd!
    autocmd BufEnter * let &titlestring=<SID>get_title_string()
    autocmd VimEnter * if &diff | cmap q qa| endif
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd FileType netrw call <SID>netrw_mappings()
    autocmd FileType vim setlocal nomodeline
    autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
augroup END
