" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " File Explorer and git wrapper
    Plug 'scrooloose/NERDTree' |
		\ Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tpope/vim-fugitive'
	" Auto pairs for '(' '[' '{' and surroundings
    Plug 'jiangmiao/auto-pairs'
	Plug 'tpope/vim-surround'
	" Easy repeats with .
	Plug 'tpope/vim-repeat'
    " Theme  and status bar
    Plug 'arcticicestudio/nord-vim'
	Plug 'itchyny/lightline.vim'
	" Language server, syntax highlighting and testing
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'sheerun/vim-polyglot'
	Plug 'janko-m/vim-test'
	" Indentation lines
	Plug 'Yggdroot/indentLine'
	call plug#end()
