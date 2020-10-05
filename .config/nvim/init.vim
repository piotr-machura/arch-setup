" -----------------------------
" NEOVIM TERMINAL EDITOR CONFIG
" -----------------------------

" PLUGINS
" -------

if empty(glob($XDG_CONFIG_HOME.'/nvim/autoload/plug.vim')) " Auto-install vim-plug
    silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin($HOME.'/.config/nvim/autoload/plugged')
" Quality of life plugins
Plug 'mbbill/undotree' " Undo tree visualized
Plug 'junegunn/vim-peekaboo' " Registers visualized
Plug 'tpope/vim-vinegar' " netrw enchancments
Plug 'tpope/vim-unimpaired' " [ - style shortucts
Plug 'jiangmiao/auto-pairs' " Auto pairs for '(' '[' '{' and surroundings
Plug 'tpope/vim-surround' " Change surrounding braces/quotes
Plug 'tpope/vim-repeat' " Easy repeats on custom commands
Plug 'tpope/vim-commentary' " Comment automation
" IDE features
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP implementation
Plug 'sheerun/vim-polyglot' " Multi-language pack
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

function! FullPluginUpgrade() 
    PlugUpgrade " Update vim-plug
    PlugUpdate " Update vim-plug extensions
    CocUpdate " Update Coc Extensions
    UpdateRemotePlugins " Neovim-specific handler update
endfunction
 
command! -nargs=0 Upgrade :call FullPluginUpgrade()

" MAPS
" ----

let mapleader=' '

" Switch between splits using hjkl
nnoremap <C-j> <C-w>j 
nnoremap <C-k> <C-w>k 
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Use the leader key to delete insted of cut
nnoremap <leader>x "_x
nnoremap <leader>d "_d
nnoremap <leader>D "_D
vnoremap <leader>d "_d

" Tool maps
nmap <unique> <Nop> <Plug>NetrwRefresh
map <silent> <leader>- :UndotreeToggle<CR>

" Disable middle mouse click actions
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

" PREFERENCES
" -----------

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
set signcolumn=yes
set number
set laststatus=2
set numberwidth=1
set title
set titlestring=\ %-25.55F\ %a%r%m titlelen=120
set noshowmode
set wrap linebreak
set splitbelow
set splitright
set hidden
set shortmess+=c

set mouse+=ar
set shellcmdflag=-ic
set autowrite
filetype plugin on
set scrolloff=6
set encoding=utf-8
set sidescrolloff=6
set updatetime=300
set backupdir=$HOME/.cache/nvim/backup
set dir=$HOME/.cache/nvim
set listchars=tab:-,trail:·
set list
set nobackup
set nowritebackup
autocmd VimEnter * if &diff | cmap q qa| endif
autocmd BufEnter * set formatoptions-=c formatoptions-=r formatoptions-=o

let g:python3_host_prog='/usr/bin/python3'
let g:AutoPairsShortcutToggle = ''

" Make netrw more berable
let g:netrw_browse_split = 0
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_altv = 1
let g:netrw_winsize = 50

" THEME
" -----

let g:nord_uniform_diff_background = 1
let g:nord_bold = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
let g:indentLine_color_term = 0
let g:indentLine_char = '|'
let g:current_branch_name = ''

colorscheme nord

" STATUSLINE
" ----------

function! BadBuffer()
    " Disable lightline elements for theeses buffer types
    let names = [
                \ "undotree",
                \ "diff",
                \ ]
    for str in names
        if stridx(&filetype, str)!=-1
            return 1
        endif
    endfor
    return 0
endfunction

function! StatusDiagnostic() abort 
    if BadBuffer()
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

" Get current git branch for lightline
let g:current_branch_name = ''
function! SetGitBranch() abort
    if BadBuffer()
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
autocmd BufEnter * call SetGitBranch()

function! FileTypeWithIcon()
    if BadBuffer()
        return ''
    endif
    return strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft'
endfunction


function! FileName()
    if BadBuffer()
        return ''
    endif
    return bufname()
endfunction

function! CurrentAndTotalLines()
    if BadBuffer()
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

let g:lightline = {
        \ 'colorscheme': 'nord',
        \ 'active': {
        \       'left': [ [ 'mode', 'paste' ],
        \                 [ 'readonly', 'filename', 'modified'] ],
        \       'right': [ [ 'cocstatus', 'gitbranch', 'filetype', 'lineinfo'] ]
        \ },
        \ 'inactive': {
        \       'right': [ [ 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'cocstatus': 'StatusDiagnostic',
        \   'gitbranch': 'GetGitBranch',
        \   'filetype': 'FileTypeWithIcon',
        \   'lineinfo': 'CurrentAndTotalLines',
        \   'filename': 'FileName'
        \ },
        \ }

" LANGUAGE SERVER
" ---------------

" Use <TAB> for completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Code navigation
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation with K
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming. and quick fix
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf  <Plug>(coc-fix-current)

" Editor commands for formatting, folding and imports
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 Imports :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>n

let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" CLIPBOARD PROVIDER
" ------------------

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


" PROSE FORMATTING
" ----------------

function CheckFilename()
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
function ApplyProseFormatting()
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
function! StartGoyo()
    if !&diff
        call lightline#init()
        Goyo
        cmap q qa
    endif
endfunction

autocmd BufEnter *.txt if !CheckFilename() | call ApplyProseFormatting() | endif
autocmd VimEnter *.txt if !CheckFilename() | call StartGoyo() | endif
" Resize goyo automatically after resizing vim
autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
