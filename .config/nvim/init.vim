" -----------------------------
" NEOVIM TERMINAL EDITOR CONFIG
" -----------------------------

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
Plug 'tpope/vim-repeat' " Easy repeats on custom commands
Plug 'tpope/vim-commentary' " Comment automation

" IDE features
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP implementation
Plug 'piotrmachura16/snippet-library' " Personalized snippet library
Plug 'janko-m/vim-test' " Testing suite

" Language packs
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'

" Visual enchancments
Plug 'arcticicestudio/nord-vim' " Theme
Plug 'itchyny/lightline.vim' " Status bar
Plug 'ap/vim-buftabline' " Buffers displayed in tabline
Plug 'Yggdroot/indentLine' " Indentation line indicators
Plug 'ryanoasis/vim-devicons' " Pretty file icons
Plug 'junegunn/goyo.vim' " Distraction-free mode
call plug#end()

" Language server extensions
let g:coc_global_extensions = [
            \ 'coc-snippets',
            \ 'coc-python',
            \ 'coc-rust-analyzer',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-json',
            \ ]

" MAPS
" ----

let mapleader=' '

" Navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

nnoremap <silent> gb :bnext<CR>
nnoremap <silent> gB :bprev<CR>

nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)

noremap <silent><expr> ZB &modified ? ':w\|bd<CR>' : ':bd<CR>'

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use the leader key to cut into black hole register
nnoremap <leader>x "_x
nnoremap <leader>s "_s
nnoremap <leader>d "_d
nnoremap <leader>D "_D

vnoremap <leader>x "_x
vnoremap <leader>s "_s
vnoremap <leader>d "_d

nnoremap <silent> <C-u> :UndotreeToggle<CR>:call buftabline#update(0)<CR>
nnoremap <silent><nowait> - :Explore<CR>

" Insert blank lines from normal mode
nnoremap <silent> [<space> O<ESC>
nnoremap <silent> ]<space> o<ESC>

" <C-space> triggers/cancels completion, <TAB><S-TAB> move around, <CR> confirms
inoremap <silent><expr> <C-space> pumvisible() ? "\<C-e>" : coc#refresh()
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
let g:coc_snippet_next = '<TAB>'

" Code actions
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <leader>r <Plug>(coc-rename)
nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>f  :<C-u>call CocAction('format')<CR>


" Disable middle mouse click actions
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

let g:AutoPairsShortcutToggle = ''

" PREFERENCES
" -----------

let g:python3_host_prog='/bin/python3'

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
set wrap linebreak

set scrolloff=4
set sidescrolloff=8

set signcolumn=yes
set number
set numberwidth=1

set splitbelow
set splitright

set title

set noshowmode
set laststatus=2
set shortmess+=c

set hidden
set switchbuf=usetab

set mouse+=ar
set shellcmdflag=-ic
set updatetime=300

set undofile
set nobackup
set autowrite
set nowritebackup

set dir=$HOME/.cache/nvim
set backupdir=$HOME/.cache/nvim/backup
set undodir=$HOME/.cache/nvim/undo

set list
set listchars=tab:-,trail:░

" Netrw configuration
let g:netrw_browse_split = 0
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_altv = 1
let g:home = $HOME

" Bufftabline options
let g:buftabline_show = 1
let g:buftabline_numbers = 2

" Undoo tree configuration
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 2
let g:undotree_HelpLine = 0
let g:undotree_ShortIndicators = 1

" Git branch name
let g:current_branch_name = ''

" Conceal settings
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
        \       'right': [ [ 'cocstatus', 'gitbranch', 'filetype', 'lineinfo' ] ]
        \ },
        \ 'inactive': {
        \       'left': [ [ 'filename' ] ],
        \       'right': [ [ 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'cocstatus': 'LightlineDiagnostic',
        \   'gitbranch': 'LightlineGitBranch',
        \   'filetype': 'LightlineFiletype',
        \   'lineinfo': 'LightlineLineinfo',
        \   'filename': 'LightlineFilename',
        \   'readonly': 'LightlineReadonly',
        \   'modified': 'LightlineModified'
        \ },
        \ }

let g:indentLine_color_term = 0
let g:indentLine_char = '|'

" CLIPBOARD
" ---------

let g:clipboard = {
  \   'name': 'xclip',
  \   'copy': {
  \      '+': 'xclip -selection clipboard',
  \      '*': 'xclip -selection clipboard',
  \    },
  \   'paste': {
  \      '+': 'xclip -selection clipboard -o',
  \      '*': 'xclip -selection clipboard -o',
  \   },
  \   'cache_enabled': 1,
  \ }
set clipboard+=unnamedplus

" FUNCTIONS
" ---------

function! s:upgrade_everything() abort
    PlugUpgrade " Update vim-plug
    PlugUpdate " Update vim-plug extensions
    CocUpdate " Update Coc Extensions
    UpdateRemotePlugins " Neovim-specific handler update
endfunction

function! s:show_documentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Lightline elements
function! s:bad_buffer() abort
    " Disable lightline elements for theeses buffer types
    let names = [
                \ "undotree",
                \ "diff",
                \ "netrw"
                \ ]
    for str in names
        if stridx(&filetype, str)!=-1
            return 1
        endif
    endfor
    return 0
endfunction

function! LightlineFiletype() abort
    if <SID>bad_buffer()
        return ''
    endif
    return strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : ''
endfunction

function! LightlineFilename() abort
    if <SID>bad_buffer()
        return ''
    endif
    return expand("%:t")
endfunction

function! LightlineLineinfo() abort
    if <SID>bad_buffer() || winwidth(0) < 35
        return ''
    endif
    let current_line = line('.')
    let total_lines = line('$')
    let column  = virtcol('.')
    let column = 'ﲒ ' . column . ' ' 
    return column . ' ' . current_line . ':' . total_lines
endfunction

function! LightlineDiagnostics() abort
    if <SID>bad_buffer() || winwidth(0) < 70
        return ''
    endif

    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    let msgs = []
    if get(info, 'error', 0)
        call add(msgs, ' ' . info['error'])
    endif
    if get(info, 'warning', 0)
        call add(msgs, ' ' . info['warning'])
    endif
    if get(info, 'information', 0)
        call add(msgs, ' ' . info['information'])
    endif
    if get(info, 'hint', 0)
        call add(msgs, ' ' . info['hint'])
    endif
    return join(msgs, ' ')
endfunction

function! s:set_git_branch() abort
    if <SID>bad_buffer()
        return ''
    endif
    let branch_name = trim(system('git branch --show-current'))
    if stridx(branch_name, 'fatal: not a git repository')!=-1
        let g:current_branch_name = ''
    else
        let g:current_branch_name = branch_name
    endif
endfunction

function! LightlineGitBranch() abort
    if len(g:current_branch_name)
        return ' ' . g:current_branch_name
    else
        return ''
    endif
endfunction

function! LightlineReadonly() abort
    if &readonly
        return ' Read-only'
    else
        return ''
    endif
endfunction

function! LightlineModified() abort
    if &modified
        return '烙'
    else
        return ''
    endif
endfunction

" Prose formatting
function! StartGoyo()
    if !&diff
        call lightline#init()
        Goyo
        cmap q qa
    endif
endfunction

function! ApplyProseFormatting() abort
    " Spellfile in the main file's dir
    let &spellfile=expand('%:p:h').'/pl.add'
    setlocal spelllang=pl,en_us
    setlocal spell
    setlocal spellsuggest+=5
    " Put dialogue dash instead of --
    iabbrev <buffer> -- —
    " Disable all automatic indentation
    setlocal noautoindent
    setlocal nobreakindent
    setlocal nosmartindent
    setlocal nocindent
    " Use tabs, not spaces
    setlocal noexpandtab
    " Line wrap modifications
    setlocal scrolloff=0
    setlocal display=lastline
    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
    setlocal nolist
endfunction

function! s:check_programming_filename() abort
    " Check for some commonly used programming .txt files
    let names = [
                \ "pkg",
                \ "PKG",
                \ "README",
                \ "readme",
                \ "license",
                \ "LICENSE",
                \ "requirements",
                \ "REQUIREMENTS",
                \ "Make",
                \ "make",
                \ ]
    for str in names
        if stridx(bufname(), str)!=-1
            return 1
        endif
    endfor
    return 0
endfunction

function! s:get_title_string() abort
    let title = " "
    let title = title . substitute(getcwd(), g:home, "~", "")
    let title = title . "  "
    let title = title . fnamemodify(expand("%"), ":~:.")
    return title
endfunction

" COMMANDS
" --------

command! -nargs=0 Upgrade :call <SID>upgrade_everything()

" AUTOCMDS
" --------

augroup git_branch
    autocmd!
    autocmd BufEnter * call <SID>set_git_branch()
augroup END

augroup diff_close
    autocmd!
    autocmd VimEnter * if &diff | cmap q qa| endif
augroup END

augroup format_options
    autocmd!
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

augroup title_string
    autocmd!
    autocmd BufEnter * let &titlestring=<SID>get_title_string()
augroup END

augroup netrw_mapping
    autocmd!
    autocmd FileType netrw nmap <buffer> l <CR>
    autocmd FileType netrw nmap <buffer> L gn
    autocmd FileType netrw nmap <buffer> h <Plug>NetrwBrowseUpDir
    autocmd FileType netrw noremap <silent><buffer> - :bd<CR>
augroup END


augroup prose_writing
    autocmd!
    autocmd BufEnter *.txt if !<SID>check_programming_filename() | call ApplyProseFormatting() | endif
    autocmd VimEnter *.txt if !<SID>check_programming_filename() | call StartGoyo() | endif
    autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
augroup END

