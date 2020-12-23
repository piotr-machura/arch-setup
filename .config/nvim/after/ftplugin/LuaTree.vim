" FILE TREE FTPLUGIN
" ------------------
setlocal statusline=%=%{\"\\uf752\"}%=
let g:indentLine_fileTypeExclude += ['LuaTree']
highlight LuaTreeGitDirty ctermfg=3
highlight LuaTreeGitNew ctermfg=4
highlight LuaTreeGitStaged ctermfg=2
highlight LuaTreeIndentMarker ctermfg=0
command! -nargs=? -bar -bang Goyo exec 'LuaTreeClose' | call goyo#execute(<bang>0, <q-args>)
augroup luatree
    autocmd BufEnter,CmdLineLeave <buffer> LuaTreeRefresh
augroup END
