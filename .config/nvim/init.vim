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

" Clipboard provider
let g:clipboard = {
  \   'name': 'xclip',
  \   'copy': {
  \      '+': 'xclip -selection clipboard',
  \      '*': 'xclip -selection clipboard',
  \    },
  \   'paste': {
  \      '+': 'xclip -selection clipboard -o',
  \      '*': 'xclip -selection clipboard -o',
  \   },
  \   'cache_enabled': 1,
  \ }
set clipboard+=unnamedplus

" .txt file formatting
autocmd BufRead,BufNewFile *.txt setlocal textwidth=80
autocmd BufRead,BufNewFile *.txt setlocal formatoptions=awt
autocmd BufRead,BufNewFile *.txt setlocal noautoindent
autocmd BufRead,BufNewFile *.txt setlocal nosmartindent
autocmd BufRead,BufNewFile *.txt setlocal nocindent
autocmd BufRead,BufNewFile *.txt let indentLine_enabled=0 
