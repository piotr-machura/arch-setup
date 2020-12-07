" PYTHON FTPLUGIN
" ---------------
setlocal makeprg=/usr/bin/python3\ %
compiler pyunit
augroup format_on_save
    autocmd!
    autocmd BufWritePre <buffer> silent! lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END
