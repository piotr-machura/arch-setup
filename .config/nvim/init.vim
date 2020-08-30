" Map the leader key to .
let mapleader=','
"Switch between splits using hjkl
no <C-j> <C-w>j| "switching to below window 
no <C-k> <C-w>k| "switching to above window
no <C-l> <C-w>l| "switching to right window 
no <C-h> <C-w>h| "switching to left window
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
set backupdir=~/.cache/nvim
set dir=~/.cache/nvim
let g:python3_host_prog = '/usr/bin/python3'

" Load plugins
source $HOME/.config/nvim/configs/plugins.vim
source $HOME/.config/nvim/configs/coc.vim
source $HOME/.config/nvim/configs/theme.vim
source $HOME/.config/nvim/configs/filetree.vim
source $HOME/.config/nvim/configs/clipboard.vim
source $HOME/.config/nvim/configs/txtformat.vim
