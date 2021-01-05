# -------------------------------
# BASH INTERACTIVE SESSION CONFIG
# -------------------------------

[[ $- != *i* ]] && return
[[ -z "$DOTPROFILE_LOADED" ]] && source "$HOME/.profile"

# ALIASES
# -------
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -lA --color=auto'
alias rm='rmtrash -I'
alias rmdir='rmdirtrash'
alias mv='mv -i'

alias py='python3'
alias mkvenv='python3 -m venv .venv && echo "Created a new virtual environment at $PWD/.venv"'
alias activate='source .venv/bin/activate'
alias pkgclean='paru -Rns $(paru -Qdtq); paru -Scc'
alias htop='echo -ne "\e]0;htop\a";htop'
alias menu-diff='vimdiff <(ls -A /usr/share/applications | grep ".desktop") <(ls -A $XDG_DATA_HOME/applications | grep ".desktop")'
alias opn='mimeopen'
alias tree='tree --dirsfirst -aCI ".git|.cache|__pycache__|.venv" --prune --filelimit 50'
alias tags='ctags -R --exclude=.git --exclude=.venv --exclude=__pycache__ *'

# PROMPT
# ------
PROMPT_COMMAND=_prompt_cmd
function _prompt_cmd() {
    prompt=""
    # SSH
    [[ -z "$SSH_CLINET" ]] || prompt="$prompt\[\e[1;33m\]\uf700 \h "
    # Jobs
    njobs=$(jobs | wc -l)
    [[ "$njobs" = "0" ]] || prompt="$prompt\[\e[1;33m\]!$njobs "
    # Python virtualenv
    venv=""
    [[ -z "$VIRTUAL_ENV" ]] || venv="$(basename "$(dirname "$VIRTUAL_ENV")")"
    [[ -z "$venv" ]] || prompt="$prompt\[\e[1;34m\]\uf81f $venv "
    # Current git branch
    branch="$(git branch --show-current 2>/dev/null)"
    [[ -z "$branch" ]] || prompt="$prompt\[\e[1;37m\]\uf418 $branch "
    # Add brackets around special info (if there is any)
    [[ -z "$prompt" ]] || prompt="\[\e[1;37m\][ $prompt\[\e[1;37m\]] "
    # Working directory
    prompt="$prompt\[\e[1;36m\]\W "
    # Add lock symbol if in non-writeable directory
    [[ -w $PWD ]] || prompt="$prompt\[\e[31m\]\uf023 "
    # Dollar sign
    prompt="$prompt\[\e[m\]\[\e[32m\]\uf155\[\e[m\] "
    # Set prompt
    export PS1="$(echo -e "$prompt")"
    # Set window title
    echo -ne "\e]0;\uf155 ${PWD/$HOME/'~'}\a"
}

# VI MODE
# -------
set -o vi
# Cursor for insert/normal mode
bind 'set show-mode-in-prompt on'
bind 'set vi-cmd-mode-string "\1\e[2 q\2"'
bind 'set vi-ins-mode-string "\1\e[6 q\2"'
bind 'set keyseq-timeout 10'
# Clear screen with CTRL-L
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# HISTORY AND COMPLETION
# ----------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1000
bind 'set show-all-if-ambiguous on'
