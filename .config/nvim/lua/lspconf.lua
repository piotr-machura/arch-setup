-- NEOVIM LSP CONFIGURATION
-- ------------------------

-- Diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        virtual_text = false,
        underline = false,
    }
)

local function attach(client)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_keymap(0, 'n', 'K','<CMD>lua vim.lsp.buf.hover()<CR>', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-]>','<CMD>lua vim.lsp.buf.definition()<CR>', {noremap=true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-t>','<CMD>lua vim.lsp.buf.references()<CR>', {noremap=true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-n>','<CMD>lua vim.lsp.buf.rename()<CR>', {noremap=true})
    vim.api.nvim_buf_set_keymap(0, '',  'gl','<CMD>lua vim.lsp.diagnostic.set_loclist()<CR>', {noremap=true})
    vim.api.nvim_buf_set_keymap(0, 'n', '[l','<CMD>silent! lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap=true})
    vim.api.nvim_buf_set_keymap(0, 'n', ']l','<CMD>silent! lua vim.lsp.diagnostic.goto_next()<CR>', {noremap=true})
    vim.api.nvim_buf_set_keymap(0, 'i', '<C-Space>','pumvisible() ? "<C-e>" : "<C-x><C-o>"', {expr=true})
end

-- Python language server
require'lspconfig'.pylsp.setup {
    on_attach = attach;
    cmd = { 'pylsp' };
    settings = {
        pylsp = {
            plugins = {
                pylint = { enabled = true },
                pydocstyle = { enabled = false, convention = 'google' },
                mccabe = { enabled = false },
            };
        };
    };
}

-- Rust language server
require'lspconfig'.rust_analyzer.setup {
    on_attach = attach;
}

-- Java language server
require'lspconfig'.jdtls.setup {
    on_attach = attach;
    cmd = {'sh', '-c', 'jdtls -data "${XDG_DATA_HOME-$HOME/.local/share}"/jdtls-workspace'};
}

-- LaTeX language server
require'lspconfig'.texlab.setup {
    on_attach = attach;
    settings = {
        texlab = {
            build = {
                args = { "%f" },
                executable = "tectonic",
                onSave = true,
            },
            formatterLineLength = 120,
            latexFormatter = "texlab",
        }
    };
}

-- Go language server
require'lspconfig'.gopls.setup {
    on_attach = attach;
}
