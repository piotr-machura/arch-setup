" Basic settings
set ts=4 sw=4
set number
set cursorline
set noshowmode
set laststatus=2
set numberwidth=1
set title
set titlestring=NVIM:\ %-25.55F\ %a%r%m titlelen=70

" Load plugins
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/nord.vim
source $HOME/.config/nvim/plug-config/lightline.vim

" MAPS
map <C-n> :NERDTreeToggle<CR>

