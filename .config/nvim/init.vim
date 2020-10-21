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
Plug 'neovim/nvim-lspconfig' " Native LSP client implementation
Plug 'nvim-lua/completion-nvim' " Native LSP completion window
Plug 'nvim-lua/diagnostic-nvim' " Native LSP diagnostics
Plug 'nvim-lua/lsp-status.nvim' " Native LSP status
Plug 'sheerun/vim-polyglot' " Multi-language pack
Plug 'janko-m/vim-test' " Testing suite

" Visual enchancments
Plug 'arcticicestudio/nord-vim' " Theme
Plug 'itchyny/lightline.vim' " Status bar
Plug 'ap/vim-buftabline' " Buffers displayed in tabline
Plug 'Yggdroot/indentLine' " Indentation line indicators
Plug 'ryanoasis/vim-devicons' " Pretty file icons
Plug 'junegunn/goyo.vim' " Distraction-free mode
call plug#end()

lua <<EOF
-- Attach the completon and diagnostic plugins

local nvim_lsp = require'nvim_lsp'

local attach_vim = function(client)
  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
end

-- Python language server
nvim_lsp.pyls.setup {
    on_attach = attach_vim;
    cmd = { "pyls" };
    settings = {
        pyls = {
            plugins = {
                mccabe = {
                    enabled = false
                },
                pylint = {
                    enabled = true
                },
                pydocstyle = {
                    enabled = false,
                    convention = "pep257"
                }
            }
        }
    };
}

-- Rust language server
nvim_lsp.rust_analyzer.setup{on_attach=attach_vim}

EOF

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

" Easy buffer switching
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

" Easy buffer closing
noremap <silent><expr> ZB &modified ? ':w\|bd<CR>' : ':bd<CR>'

" Use the leader key to cut into black hole register
nnoremap <leader>x "_x
nnoremap <leader>s "_s
nnoremap <leader>d "_d
nnoremap <leader>D "_D

vnoremap <leader>x "_x
vnoremap <leader>s "_s
vnoremap <leader>d "_d

" Undo tree and netrw shortcuts
nnoremap <silent> <C-u> :UndotreeToggle<CR>:call buftabline#update(0)<CR>
nnoremap <silent><nowait> - :Explore<CR>

" Built-in terminal
tnoremap <S-Esc> <C-\><C-n>

" Insert blank lines above or below from normal mode
nnoremap <silent> [<space> O<ESC>
nnoremap <silent> ]<space> o<ESC>

" Resotre hlsearch wneh n or N is pressed
nnoremap <silent> n n:set hlsearch<CR>
nnoremap <silent> N N:set hlsearch<CR>

" <C-space> triggers/cancels completion, <TAB><S-TAB> move around, <CR> confirms
imap <silent><expr><C-space> pumvisible() ? "\<C-e>" : "<Plug>(completion_trigger)"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" Code actions
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>r :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>f :lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>

nmap <silent> [g :PrevDiagnosticCycle<CR>
nmap <silent> ]g :NextDiagnosticCycle<CR>

nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>

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

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
set wrap linebreak

set scrolloff=4
set sidescrolloff=8

set signcolumn=number
set number
set numberwidth=3

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

let g:python3_host_prog='/usr/bin/python3'

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

" Language pack settings
let g:vim_json_syntax_conceal = 0

let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

let g:python_highlight_space_errors = 0
let g:python_highlight_indent_errors = 1
let g:python_highlight_class_vars = 1
let g:python_highlight_exceptions = 1

" Completion settings
set completeopt=menuone,noinsert,noselect
let g:completion_enable_auto_signature = 1
let g:completion_matching_ignore_case = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_paren = 1

" Diagnostic settings
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_insert_delay = 1
let g:diagnostic_virtual_text_prefix = ' '
let g:space_before_virtual_text = 4

call sign_define("LspDiagnosticsErrorSign", {"text" : "", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsHint"})

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
        \       'right': [ [ 'diagnostics', 'gitbranch', 'filetype', 'lineinfo' ] ]
        \ },
        \ 'inactive': {
        \       'left': [ [ 'filename' ] ],
        \       'right': [ [ 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'diagnostics': 'LightlineDiagnostics',
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
    UpdateRemotePlugins " Neovim-specific handler update
endfunction

" Lightline elements
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

    let info = luaeval("require('lsp-status').diagnostics()")

    if empty(info) | return '' | endif
    let msgs = []
    if get(info, 'errors', 0)
        call add(msgs, ' ' . info['errors'])
    endif
    if get(info, 'warnings', 0)
        call add(msgs, ' ' . info['warnings'])
    endif
    if get(info, 'info', 0)
        call add(msgs, ' ' . info['info'])
    endif
    if get(info, 'hints', 0)
        call add(msgs, ' ' . info['hints'])
    endif
    return join(msgs, ' ')
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
    autocmd BufReadPost * call <SID>set_git_branch()
augroup END

augroup diff_close
    autocmd!
    autocmd VimEnter * if &diff | cmap q qa| endif
augroup END

augroup formatting
    autocmd!
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
    autocmd BufWritePre *.rs,*.py lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END

augroup title_string
    autocmd!
    autocmd DirChanged,BufWinEnter * let &titlestring=<SID>get_title_string()
augroup END

augroup clear_search
    autocmd!
    autocmd CursorMoved * set nohlsearch
augroup END

augroup netrw_mapping
    autocmd!
    autocmd FileType netrw nmap <buffer> l <CR>
    autocmd FileType netrw nmap <buffer> L gn
    autocmd FileType netrw nmap <buffer> h <Plug>NetrwBrowseUpDir
    autocmd FileType netrw noremap <silent><buffer> - :bd<CR>
    autocmd FileType <buffer> set eventignore+=CursorHold
augroup END

augroup terminal_settings
    autocmd!
    autocmd TermEnter * setlocal nonumber
    autocmd TermEnter * setlocal bufhidden=""
    autocmd TermEnter * setlocal nomodifiable
augroup END

augroup prose_writing
    autocmd!
    autocmd BufEnter *.txt if !<SID>check_programming_filename() | call ApplyProseFormatting() | endif
    autocmd VimEnter *.txt if !<SID>check_programming_filename() | call StartGoyo() | endif
    autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
augroup END
