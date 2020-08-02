" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " Theme 
    Plug 'arcticicestudio/nord-vim'
    " Lightline status bar
	Plug 'itchyny/lightline.vim'
	" Language server
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	" Git wrapper
	Plug 'tpope/vim-fugitive'

	call plug#end()
