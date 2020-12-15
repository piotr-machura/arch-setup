-- LSP CONFIGURATION
-- -----------------
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        virtual_text = false,
        underline = false,
    }
)

-- Python language server
require'lspconfig'.pyls.setup {
    on_attach = require'completion'.on_attach(client);
    cmd = { "pyls" };
    settings = {
        pyls = {
            plugins = {
                pylint = { enabled = true },
                pydocstyle = { enabled = false, convention = "google" },
                mccabe = { enabled = false },
            }
        }
    };
}