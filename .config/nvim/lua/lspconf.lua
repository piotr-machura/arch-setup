-- LSP CONFIGURATION
-- -----------------
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        virtual_text = false,
        underline = false,
    }
)

local function attach(client)
    local map = vim.api.nvim_buf_set_keymap
    map(0, 'n', '<C-h>','<CMD>lua vim.lsp.buf.hover()<CR>', {noremap = true})
    map(0, 'n', '<C-]','<CMD>lua vim.lsp.buf.definition()<CR>', {noremap=true})
    map(0, 'n', '<C-t>','<CMD>lua vim.lsp.buf.references()<CR>', {noremap=true})
    map(0, 'n', '<leader>r','<CMD>lua vim.lsp.buf.rename()<CR>', {noremap=true})
    map(0, '',  'gq','<CMD>lua vim.lsp.diagnostic.set_loclist()<CR>', {noremap=true})
    map(0, 'n', '[q','<CMD>silent! lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap=true})
    map(0, 'n', ']q','<CMD>silent! lua vim.lsp.diagnostic.goto_next()<CR>', {noremap=true})
    map(0, 'i', '<C-Space>','pumvisible() ? "<C-e>" : "<Plug>(completion_trigger)"', {expr = true})
    require'completion'.on_attach(client)
end

-- Python language server
require'lspconfig'.pyls.setup {
    on_attach = attach;
    cmd = { 'pyls' };
    settings = {
        pyls = {
            plugins = {
                pylint = { enabled = true },
                pydocstyle = { enabled = false, convention = 'google' },
                mccabe = { enabled = false },
            }
        }
    };
}
