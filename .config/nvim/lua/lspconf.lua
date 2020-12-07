-- LSP CONFIGURATION
-- -----------------
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = false,
        update_in_insert = false,
    }
)

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
