# ---------------
# ZSH ENVIRONMENT
# ---------------

[[ -z $DOTPROFILE_LOADED ]] && source "$HOME/.profile"

# ALIASES
# -------
alias -g ...='../..'
alias -g ....='../../..'

alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -lA --color=auto'
alias rm='rmtrash -I'
alias rmdir='rmdirtrash'
alias mv='mv -i'

alias py='python3'
alias venv='python3 -m venv .venv && echo "Created a new virtual environment at $PWD/.venv"'
alias activate='source .venv/bin/activate'
alias pkgclean='paru -Rns $(paru -Qdtq); paru -Scc'
alias htop='print -Pn "\e]0;htop\a";htop' # Change htop window title
alias menu-diff='vimdiff <(ls -A /usr/share/applications | grep ".desktop") <(ls -A $XDG_DATA_HOME/applications | grep ".desktop")'
alias open='mimeopen'
alias tree='tree --dirsfirst -aCI ".git|.cache|__pycache__|.venv" --prune --filelimit 50'
alias tags='ctags -R --exclude=.git --exclude=.venv --exclude=__pycache__ *'
