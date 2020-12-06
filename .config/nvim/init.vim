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
call plug#end()

" SETTINGS
" --------
set tabstop=4   softtabstop=4   shiftwidth=4    expandtab   shiftround
set nowrap      scrolloff=4     cursorline      sidescrolloff=8
set number      relativenumber  numberwidth=3   signcolumn=number
set noshowmode  updatetime=300  confirm         shortmess+=c
set hidden      conceallevel=2  concealcursor=""
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

"Theme configuration
let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord

" Statusline configuration
let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'active': {
    \ 'left': [ ['mode'], ['filename'], ['readonly', 'modified'] ],
    \ 'right': [ ['filetype', 'lineinfo'] ]
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
    \ }

" Indentline configuration
let g:indentLine_color_term = 0
let g:indentLine_char = '|'
let g:indentLine_setConceal = 0

" Goyo configuration
let g:goyo_height = '100%'
let g:goyo_width = 80
let g:goyo_linenr = 0

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

" Disable middle mouse click
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>

" Other maps
nnoremap <silent> <C-u> :UndotreeToggle<CR>
nnoremap <silent><nowait> - :Explore<CR>
tnoremap <C-\> <C-\><C-n>
nnoremap <silent> <leader>g :Goyo<CR>
nnoremap <silent> <leader>s :call <SID>strip_whitespace()<CR>
let g:AutoPairsShortcutToggle = "\<C-p>"

" FUNCTIONS
" ---------
function! s:strip_whitespace() abort
    let last_search = @/
    %substitute/\s\+$//e
    let @/ = last_search
    nohlsearch
    unlet last_search
    echo 'Stripped trailing whitespace'
endfunction

" AUTOCMDS
" --------
augroup user_created
    autocmd!
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
augroup END
