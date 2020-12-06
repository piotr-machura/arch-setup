" -----------------------------
" NEOVIM LANGUAGE SERVER CONFIG
" -----------------------------
" Note: add the appropriete sections in init.vim
" in order to get lsp functionality

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

" Put this in /after/ftplugin/python.vim
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
" <C-space> triggers/cancells lsp completion
imap <silent><expr><C-space> pumvisible() ? "\<C-e>" : "<Plug>(completion_trigger)"

" Code actions
nnoremap <silent> <C-h> :call <SID>code_action('hover')<CR>
nnoremap <silent> <leader>r :call <SID>code_action('rename')<CR>
nnoremap <silent> <leader>f :call <SID>code_action('format')<CR>
nnoremap <silent> <leader>o :call <SID>code_action('diagnostics')<CR>
nnoremap <silent> [o :call <SID>code_action('diagnostics_prev')<CR>
nnoremap <silent> ]o :call <SID>code_action('diagnostics_next')<CR>
nnoremap <silent> gd :call <SID>code_action('definition')<CR>
nnoremap <silent> gr :call <SID>code_action('references')<CR>

" SETTINGS
" --------
let g:current_branch_name = ''

let g:completion_enable_auto_signature = 1
let g:completion_matching_ignore_case = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_paren = 1

" Note: this is deprecated
call sign_define("LspDiagnosticsErrorSign", {"text" : "", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsHint"})

" Lightline components
" Note: this must be added after the lightline dictionary is declared
call insert(g:lightline['active']['right'][0], 'gitbranch')
call insert(g:lightline['active']['right'], ['diagnostics'])
let g:lightline['component_function'] = {'gitbranch' : 'LightlineGitbranch', 'diagnostics' : 'LightlineDiagnostics'}

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

function! s:code_action(action) abort
    if empty(luaeval("vim.lsp.get_active_clients()"))
        echo 'No active language server.'
        return
    endif
    let actions = {
        \ 'hover' : 'vim.lsp.buf.hover()'
        \ 'format' : 'vim.lsp.buf.formatting_sync(nil, 1000)',
        \ 'rename' : 'vim.lsp.buf.rename()',
        \ 'diagnostics' : 'vim.lsp.diagnostic.set_loclist()',
        \ 'diagnostics_prev' : 'vim.lsp.diagnostic.goto_prev()',
        \ 'diagnostics_next' : 'vim.lsp.diagnostic.goto_next()',
        \ 'definition' : 'vim.lsp.buf.definition()',
        \ 'references' : 'vim.lsp.buf.references()',
        \ }
    call luaeval(actions[a:action])
    unlet actions
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
    if len(g:current_branch_name) | return ' ' . g:current_branch_name | endif
    return ''
endfunction

" AUTOCMDS
" --------
augroup lsp_config
    autocmd!
    autocmd BufWritePre *.rs,*.py silent! lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd VimEnter,DirChanged * call <SID>set_git_branch()
augroup END
