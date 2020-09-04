" Map the leader key to ','
let mapleader=','
"Switch between splits using hjkl
nnoremap <C-j> <C-w>j 
nnoremap <C-k> <C-w>k 
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
" Use the leader key to delete insted of cut 
nnoremap <leader>x "_x
nnoremap <leader>d "_d
nnoremap <leader>D "_D
vnoremap <leader>d "_d

" Basic settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
set number
set cursorline
set laststatus=2
set numberwidth=1
set title
set titlestring=Neovim:\ %-25.55F\ %a%r%m titlelen=70
set noshowmode
set nowrap
set splitbelow
set splitright
set autowrite
set scrolloff=6
set encoding=utf-8
set sidescrolloff=6
set backupdir=$XDG_CACHE_HOME/nvim/backup
set dir=$XDG_CACHE_HOME/nvim
let g:python3_host_prog = '/usr/bin/python3'

" Load plugins
source $XDG_CONFIG_HOME/nvim/plugins.vim
source $XDG_CONFIG_HOME/nvim/coc.vim
source $XDG_CONFIG_HOME/nvim/theme.vim
source $XDG_CONFIG_HOME/nvim/clipboard.vim
source $XDG_CONFIG_HOME/nvim/nerdtree.vim
source $XDG_CONFIG_HOME/nvim/txtformat.vim
