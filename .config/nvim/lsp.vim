" -----------------------------
" NEOVIM LANGUAGE SERVER CONFIG
" -----------------------------
" Note: source this in the init.vim and run :PlugInstall
" in order to get lsp functionality

" PLUGINS
" -------

Plug 'neovim/nvim-lspconfig' " Native LSP client implementation
Plug 'nvim-lua/completion-nvim' " Native LSP completion window
Plug 'nvim-lua/lsp-status.nvim' " Native LSP status
Plug 'janko-m/vim-test' " Testing suite
Plug 'ap/vim-buftabline' " Buffers displayed in tabline
call plug#end()
let g:did_plug_end = 1

" LSP CLIENT
" ----------

lua <<EOF

-- Python language server
require'lspconfig'.pyls.setup {
    on_attach = require'completion'.on_attach(client);
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
require'lspconfig'.rust_analyzer.setup{
    on_attach=require'completion'.on_attach(client)
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
            spacing = 4,
            prefix = ' ',
        },
        update_in_insert = false,
    }
)
EOF

" MAPS
" ----

nmap g1 <Plug>BufTabLine.Go(1)
nmap g2 <Plug>BufTabLine.Go(2)
nmap g3 <Plug>BufTabLine.Go(3)
nmap g4 <Plug>BufTabLine.Go(4)
nmap g5 <Plug>BufTabLine.Go(5)
nmap g6 <Plug>BufTabLine.Go(6)
nmap g7 <Plug>BufTabLine.Go(7)
nmap g8 <Plug>BufTabLine.Go(8)
nmap g9 <Plug>BufTabLine.Go(9)
nmap g0 <Plug>BufTabLine.Go(10)

" <C-space> triggers/cancels completion, <TAB><S-TAB> move around, <CR> confirms
imap <silent><expr><C-space> pumvisible() ? "\<C-e>" : "<Plug>(completion_trigger)"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" Code actions
nnoremap <silent> <leader>h :silent! lua vim.lsp.buf.hover()<CR>
nnoremap <leader>r :silent! lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>f :silent! lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>
nnoremap <silent> <leader>o :silent! lua vim.lsp.diagnostic.set_loclist()<CR>
nmap <silent> [g :silent! lua vim.lsp.diagnostic.goto_prev()<CR>
nmap <silent> ]g :silent! lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gd :silent! lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gr :silent! lua vim.lsp.buf.references()<CR>

" SETTINGS
" --------

let g:python3_host_prog='/usr/bin/python3'

let test#strategy = 'neovim'
let g:current_branch_name = ''
let g:buftabline_show = 1
let g:buftabline_numbers = 2

let g:python_highlight_space_errors = 0
let g:python_highlight_indent_errors = 1
let g:python_highlight_class_vars = 1
let g:python_highlight_exceptions = 1

set completeopt=menuone,noinsert,noselect
let g:completion_enable_auto_signature = 1
let g:completion_matching_ignore_case = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_paren = 1

call sign_define("LspDiagnosticsErrorSign", {"text" : "", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsHint"})

" Add lightline components
call insert(g:lightline['active']['right'][0], 'gitbranch')
call insert(g:lightline['active']['right'], ['diagnostics'])
let g:lightline['component_function']['gitbranch'] = 'LightlineGitbranch'
let g:lightline['component_function']['diagnostics'] = 'LightlineDiagnostics'

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

function! LightlineDiagnostics() abort
    return ""
    if <SID>bad_buffer() || winwidth(0) < 70 | return '' | endif
    if empty(info) | return '' | endif
    let info = luaeval("require('lsp-status').diagnostics()")
    let msgs = []
    if get(info, 'errors', 0) | call add(msgs, ' ' . info['errors']) | endif
    if get(info, 'warnings', 0) | call add(msgs, ' ' . info['warnings']) | endif
    if get(info, 'info', 0) | call add(msgs, ' ' . info['info']) | endif
    if get(info, 'hints', 0) | call add(msgs, ' ' . info['hints']) | endif
    return join(msgs, ' ')
endfunction

function! LightlineGitbranch() abort
    if len(g:current_branch_name) | return " " . g:current_branch_name | endif
    return ""
endfunction

" AUTOCMD
" -------

augroup lsp_config
    autocmd!
    autocmd BufWritePre *.rs,*.py silent! lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd VimEnter,DirChanged * call <SID>set_git_branch()
augroup END
