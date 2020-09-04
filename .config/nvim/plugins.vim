" Auto-install vim-plug
if empty(glob($XDG_CONFIG_HOME.'/nvim/autoload/plug.vim'))
    silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin($XDG_CONFIG_HOME.'/nvim/autoload/plugged')

    " File Explorer and git wrapper
    Plug 'scrooloose/NERDTree' |
        \ Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tpope/vim-fugitive'
    " Auto pairs for '(' '[' '{' and surroundings
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-surround'
    " Easy repeats with .
    Plug 'tpope/vim-repeat'
    " Theme, icons  and status bar
    Plug 'arcticicestudio/nord-vim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'itchyny/lightline.vim'
    " Language server, syntax highlighting and testing
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'sheerun/vim-polyglot'
    Plug 'janko-m/vim-test'
    " Indentation lines
    Plug 'Yggdroot/indentLine'
    call plug#end()

" Editor functions perforimng a full plugin installation & upgrade
function! FullPluginInstall()
    " Install vim-plug extensions
    PlugInstall
    " Install the coc extensions listed in
    " $HOME/.config/coc/extensions/package.json and press space to continue
    !cd $XDG_CONFIG_HOME/coc/extensions; npm install;
endfunction

function! FullPluginUpgrade() 
    " Update vim-plug extensions
    PlugUpdate
    PlugUpgrade
    " Update Coc Extensions
    CocUpdate
endfunction

command! -nargs=0 Install :call FullPluginInstall()
command! -nargs=0 Upgrade :call FullPluginUpgrade()
