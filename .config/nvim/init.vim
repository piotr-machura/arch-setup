" -----------------------------
" NEOVIM TERMINAL EDITOR CONFIG
" -----------------------------
" Note: this is a minimal version, without any IDE features

" PLUGINS
" -------

if empty(glob($HOME.'/.config/nvim/autoload/plug.vim')) " Auto-install vim-plug
    silent !curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin($HOME.'/.config/nvim/autoload/plugged')
" Quality of life plugins
Plug 'mbbill/undotree' " Undo tree visualized
Plug 'junegunn/vim-peekaboo' " Registers visualized
Plug 'jiangmiao/auto-pairs' " Auto pairs for '(' '[' '{' and surroundings
Plug 'tpope/vim-surround' " Change surrounding braces/quotes
Plug 'tpope/vim-commentary' " Comment automation
Plug 'tpope/vim-repeat' " Repeta surroundings/commentary with '.'
Plug 'sheerun/vim-polyglot' " Multi-language pack

" Visual enchancments
Plug 'arcticicestudio/nord-vim' " Theme
Plug 'itchyny/lightline.vim' " Status bar
Plug 'Yggdroot/indentLine' " Indentation line indicators
Plug 'junegunn/goyo.vim' " Distraction-free mode
call plug#end()

" MAPS
" ----

" Navigation
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
inoremap <A-h> <Esc><C-w>h
inoremap <A-j> <Esc><C-w>j
inoremap <A-k> <Esc><C-w>k
inoremap <A-l> <Esc><C-w>l
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

noremap <silent><expr> ZB &modified ? ':w\|bd<CR>' : ':bd!<CR>'
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

" Undotree, netrw, terminal shortcuts
nnoremap <silent> U :UndotreeToggle<CR>
nnoremap <silent><nowait> - :Explore<CR>
tnoremap <C-\> <C-\><C-n>

" Line splitting from normal mode
nnoremap <silent> [<space> O<ESC>
nnoremap <silent> ]<space> o<ESC>
nnoremap <silent> K a<CR><ESC>

" Disable middle mouse click
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

" Disable autopair toggling
let g:AutoPairsShortcutToggle = ''

" PREFERENCES
" -----------

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab shiftround
set wrap linebreak scrolloff=4
set number numberwidth=3
set splitbelow splitright
set noshowmode laststatus=2 title
set conceallevel=2 shortmess+=c hidden
set shellcmdflag=-ic updatetime=300 switchbuf=usetab
set undofile nobackup autowrite nowritebackup
set dir=$HOME/.cache/nvim
set backupdir=$HOME/.cache/nvim/backup
set undodir=$HOME/.cache/nvim/undo
set list listchars=tab:-,trail:░
set mouse+=ar

" Netrw configuration
let g:netrw_browse_split = 0
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_altv = 1
let g:home = $HOME
let g:current_branch_name = ''
let g:netrw_localrmdir='rm -r'

" Undoo tree configuration
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2
let g:undotree_HelpLine = 0
let g:undotree_ShortIndicators = 1

" Language pack settings
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
        \       'left': [ [ 'mode' ], ['readonly', 'filename', 'modified'] ],
        \       'right': [ [ 'gitbranch', 'filetype', 'lineinfo' ] ]
        \ },
        \ 'inactive': {
        \       'left': [ [ 'filename' ] ], 'right': [ [ 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'LightlineGitbranch',
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

function! s:set_git_branch() abort
    let git_output = trim(system('git branch --show-current'))
    if stridx(git_output, 'fatal: not a git repository')!=-1
        let g:current_branch_name = ''
    else
        let g:current_branch_name = git_output
    endif
endfunction

function! s:bad_buffer() abort
    " Disable lightline elements for theeses buffer types
    let names = [ "undotree", "diff", "netrw", "vim-plug" ]
    for str in names | if stridx(&filetype, str)!=-1 | return 1 | endif | endfor
    return 0
endfunction

function! s:get_title_string() abort
    let old_title = &titlestring
    if <SID>bad_buffer() | return old_title | endif
    return " ". substitute(getcwd(), g:home, "~", "")."  ".fnamemodify(expand("%"), ":~:.")
endfunction

function s:prose_ftplugin() abort
    " Spellfile in the same dir as the file itself
    let &spellfile=expand('%:p:h').'/pl.add'
    setlocal spell spelllang=pl,en_us spellsuggest+=5
    " Put dialogue dash instead of --
    iabbrev <buffer> -- —
    setlocal noautoindent nobreakindent nosmartindent nocindent noexpandtab
    setlocal scrolloff=0 display=lastline nolist nonumber
    " Conceal the call to vim filetype
    syntax match Normal '# vim: set filetype=prose:' conceal
    " Keyboard shortcuts
    nnoremap <buffer><silent> <leader>f :Goyo<CR>
    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
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
    return strlen(&filetype) || <SID>bad_buffer() ? ' '.&filetype : ''
endfunction
function! LightlineFilename() abort
    return <SID>bad_buffer() ? "" : expand("%:t") 
endfunction
function! LightlineLineinfo() abort
    return <SID>bad_buffer() || winwidth(0) < 35 ? '' : 'ﲒ '.virtcol('.').'  '.line('.').':'.line('$') 
endfunction
function! LightlineGitbranch() abort
    if len(g:current_branch_name) | return " " . g:current_branch_name | endif
    return ""
endfunction
function! LightlineReadonly() abort
    return &readonly ? "ﰸ Read-only" :  ""
endfunction
function! LightlineModified() abort
    return &modified ? " " : ""
endfunction

" AUTOCMDS
" --------

augroup user_created
    autocmd!
    autocmd VimEnter,DirChanged * call <SID>set_git_branch()
    autocmd BufEnter * let &titlestring=<SID>get_title_string()
    autocmd VimEnter * if &diff | cmap q qa| endif
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber
    autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd FileType netrw call <SID>netrw_mappings()
    autocmd FileType prose call <SID>prose_ftplugin()
augroup END
