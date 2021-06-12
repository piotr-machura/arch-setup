" TEX FTPLUGIN
" ------------
setlocal textwidth=100
setlocal spell
let g:tex_conceal = 'db'

augroup tex
autocmd!
autocmd BufWritePost *.tex if luaeval('vim.lsp.buf.server_ready()') | exec 'TexlabBuild' | endif
augroup END

