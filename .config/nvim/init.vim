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
Plug 'tpope/vim-vinegar' " netrw enchancments
Plug 'jiangmiao/auto-pairs' " Auto pairs for '(' '[' '{' and surroundings
Plug 'tpope/vim-surround' " Change surrounding braces/quotes
Plug 'tpope/vim-repeat' " Easy repeats on custom commands
Plug 'tpope/vim-commentary' " Comment automation

" IDE features
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP implementation
Plug 'sheerun/vim-polyglot' " Multi-language pack
Plug 'piotrmachura16/snippet-library' " Personalized snippet library
Plug 'janko-m/vim-test' " Testing suite

" Visual enchancments
Plug 'junegunn/goyo.vim' " Distraction-free mode
Plug 'arcticicestudio/nord-vim' " Theme
Plug 'itchyny/lightline.vim' " Status bar
Plug 'Yggdroot/indentLine' " Indentation line indicators
Plug 'ryanoasis/vim-devicons' " Pretty file icons
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

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

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

nnoremap <silent> <C-u> :UndotreeToggle<CR>
nnoremap <silent> <leader>l :ls<CR>:buffer<space>

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
let &titlestring="  %-25.55F %a%r%m"

set noshowmode
set laststatus=2
set hidden
set shortmess+=c

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
        \       'left': [ [ 'mode', 'paste' ],
        \                 [ 'readonly', 'filename', 'modified'] ],
        \       'right': [ [ 'cocstatus', 'gitbranch', 'filetype', 'buffer', 'lineinfo' ] ]
        \ },
        \ 'inactive': {
        \       'left': [ [ 'filename' ] ],
        \       'right': [ [ 'filetype', 'buffer' ] ]
        \ },
        \ 'component_function': {
        \   'cocstatus': 'StatusDiagnostic',
        \   'gitbranch': 'GetGitBranch',
        \   'filetype': 'FileTypeWithIcon',
        \   'lineinfo': 'CurrentAndTotalLines',
        \   'filename': 'FileName',
        \   'buffer': 'BuffNumber',
        \ },
        \ }

let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'

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

" COMMANDS
" --------

command! -nargs=0 Upgrade :call <SID>upgrade_everything()

" AUTOCMDS
" --------

autocmd VimEnter,ShellCmdPost * call <SID>set_git_branch()
autocmd VimEnter * if &diff | cmap q qa| endif
autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o

augroup prosewriting
    autocmd!
    autocmd BufEnter *.txt if !<SID>check_programming_filename() | call ApplyProseFormatting() | endif
    autocmd VimEnter *.txt if !<SID>check_programming_filename() | call StartGoyo() | endif
    autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
augroup END

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

function! FileTypeWithIcon() abort
    if <SID>bad_buffer()
        return ''
    endif
    return strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : ''
endfunction

function! FileName() abort
    if <SID>bad_buffer()
        return ''
    endif
    return expand('%:t')
endfunction

function! CurrentAndTotalLines() abort
    if <SID>bad_buffer()
        return ''
    endif
    let current_line = line('.')
    let current_v_line = line('v')
    let total_lines = line('$')
    let column  = virtcol('.')
    let column = 'ﲒ ' . column . ' ' 
    let current_mode = mode()
    if current_mode!= "v" && current_mode != "V" && current_mode != "\<C-V>"
        return column . ' ' . current_line . ':' . total_lines
    elseif current_line > current_v_line
        return column . 'ﬕ ' . current_v_line . '-' . current_line
    else
        return column . 'ﬕ ' . current_line . '-' . current_v_line
    endif
endfunction

function! StatusDiagnostic() abort 
    if <SID>bad_buffer()
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

function! BuffNumber() abort
    return '﬒ ' . len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

function! s:set_git_branch() abort
    if <SID>bad_buffer()
        return ''
    endif
    let branch_name = trim(system('git branch --show-current'))
    if stridx(branch_name, 'fatal: not a git repository')!=-1
        let g:current_branch_name = ''
    else
        let g:current_branch_name = ' ' . branch_name
    endif
endfunction

function! GetGitBranch() abort
    return g:current_branch_name
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
                \ "REQUIREMENTS"
                \ ]
    for str in names
        if stridx(bufname(), str)!=-1
            return 1
        endif
    endfor
    return 0
endfunction
