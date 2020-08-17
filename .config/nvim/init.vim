" Load plugins
source $HOME/.config/nvim/vim-plug/plugins.vim

" Load plugin configuration
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/nord.vim
source $HOME/.config/nvim/plug-config/lightline.vim
source $HOME/.config/nvim/plug-config/nerdtree.vim
source $HOME/.config/nvim/plug-config/nerdtree-git-plugin.vim
source $HOME/.config/nvim/plug-config/polyglot.vim
source $HOME/.config/nvim/plug-config/indentline.vim

" Load clipboard provider script
source $HOME/.config/nvim/clipboard.vim

" Basic settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set cursorline
set laststatus=2
set numberwidth=1
set title
set titlestring=Neovim:\ %-25.55F\ %a%r%m titlelen=70
set noshowmode
set splitbelow
set splitright


"Switch between different windows by their direction`
no <C-j> <C-w>j| "switching to below window 
no <C-k> <C-w>k| "switching to above window
no <C-l> <C-w>l| "switching to right window 
no <C-h> <C-w>h| "switching to left window
" use the leader key to delete insted of cut 
nnoremap <leader>x "_x
nnoremap <leader>d "_d
nnoremap <leader>D "_D
vnoremap <leader>d "_d
