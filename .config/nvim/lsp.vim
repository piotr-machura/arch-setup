" -----------------------------
" NEOVIM LANGUAGE SERVER CONFIG
" -----------------------------
" Note: add the appropriete sections in init.vim in order
" to get lsp functionality on latest neovim nightly

" PLUGINS
" -------
Plug 'neovim/nvim-lspconfig' " Native LSP client implementation
Plug 'nvim-lua/completion-nvim' " Native LSP completion window
Plug 'nvim-lua/lsp-status.nvim' " Native LSP status

" LSP CLIENT
" ----------
lua << EOF
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

" Note: put this in after/ftplugin/python.vim
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
EOF

" MAPS
" ----
" LSP completion
imap <expr> <C-space> pumvisible() ?
            \ "\<C-e>" : <SID>attached() ? "<Plug>(completion_trigger)" : "\<C-n>"

" LSP code actions
nnoremap <expr> <C-h> <SID>attached() ?
            \ "<cmd>lua vim.lsp.buf.hover()<CR>" : "\K"
nnoremap <expr> # <SID>attached() ?
            \ "<cmd>lua vim.lsp.buf.rename()<CR>" : "#"
nnoremap <expr> [d <SID>attached() ?
            \ "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>" : "\[d"
nnoremap <expr> ]d <SID>attached() ?
            \ "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>" : "\]d"
nnoremap <expr> <C-]> <SID>attached() ?
            \ "<cmd>lua vim.lsp.buf.definition()<CR>" : "\<C-]>"
nnoremap <expr> <C-t> <SID>attached() ?
            \ "<cmd>lua vim.lsp.buf.references()<CR>" : "\<C-t>"

" SETTINGS
" --------
let g:current_branch_name = ''

let g:completion_enable_auto_signature = 1
let g:completion_matching_ignore_case = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_paren = 1

call sign_define("LspDiagnosticsErrorSign", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsVirtualTextHint"})

" Note: this must be added after the lightline dictionary is declared
call insert(g:lightline['active']['right'][0], 'gitbranch')
call insert(g:lightline['active']['right'], ['diagnostics'])
let g:lightline['component_function'] = {'gitbranch' : 'LightlineGitbranch', 'diagnostics' : 'LightlineDiagnostics'}

" TODO: make these do other thing when lsp is not availible
command! Format lua vim.lsp.buf.formatting_sync(nil, 1000)
command! Diagnostic lua vim.lsp.diagnostic.set_loclist()

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

function! s:attached() abort
    return !empty(luaeval("vim.lsp.buf_get_clients(0)"))
endfunction

function! LightlineDiagnostics() abort
    if winwidth(0) < 70 | return '' | endif
    let info = luaeval("require('lsp-status').diagnostics()")
    if empty(info) | return '' | endif
    let msgs = []
    if get(info, 'errors', 0) | call add(msgs, ' ' . info['errors']) | endif
    if get(info, 'warnings', 0) | call add(msgs, ' ' . info['warnings']) | endif
    if get(info, 'info', 0) | call add(msgs, ' ' . info['info']) | endif
    if get(info, 'hints', 0) | call add(msgs, ' ' . info['hints']) | endif
    return join(msgs, ' ')
endfunction

function! LightlineGitbranch() abort
    if !empty(g:current_branch_name) && winwidth(0) > 50
        return ' ' . g:current_branch_name
    endif
    return ''
endfunction

" AUTOCMDS
" --------
" Note: add this to after/ftplugin/<filetype to autoformat>.vim
augroup format_on_save
    autocmd!
    autocmd BufWritePre <buffer> silent! lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END

augroup git
    autocmd!
    autocmd VimEnter,DirChanged * call <SID>set_git_branch()
augroup END
