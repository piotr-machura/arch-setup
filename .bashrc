# -------------------------------
# BASH INTERACTIVE SESSION CONFIG
# -------------------------------

[[ $0 != *bash ]] && return
[[ $- != *i* ]] && return

# ALIASES
# -------
alias ls='ls --color=auto'
alias la='ls --almost-all --color=auto'
alias ll='ls -l --almost-all --block-size=K --color=auto'
alias rm='rmtrash --interactive=once --forbid-root=pass'
alias rf='\rm --recursive --force'
alias rmdir='rmdirtrash --forbid-root=pass'
alias mv='mv --interactive --verbose'
alias root='root -l'
alias ping='ping -c 5'
alias htop='echo -ne "\e]0;htop\a";htop'
alias tree='tree --dirsfirst -aCI ".git|.cache|__pycache__|.venv|node_modules|target" --prune --filelimit 50'

alias mkvenv='python3 -m venv .venv && echo "Created a new virtual environment at $PWD/.venv"'
alias activate='source $PWD/.venv/bin/activate'
alias pkgclean='paru -Rns $(paru -Qdtq --noconfirm); paru -Scc'
alias menu-diff='vimdiff <(ls /usr/share/applications | grep ".desktop") <(ls $XDG_DATA_HOME/applications | grep ".desktop")'

# PROMPT
# ------
function _prompt_cmd() {
    # Set window title
    case $TERM in
        xterm*) echo -ne "\e]0;\uf155 ${PWD/$HOME/'~'}\a" ;;
    esac
    # Contruct the prompt
    prompt=""
    # Python virtualenv
    venv=""
    [[ ! -z "$VIRTUAL_ENV" ]] && venv="$(basename "$(dirname "$VIRTUAL_ENV")")"
    [[ ! -z "$venv" ]] && prompt="$prompt\uf81f $venv "
    # Current git branch
    branch="$(git branch --show-current 2>/dev/null)"
    [[ ! -z "$branch" ]] && prompt="$prompt\uf418 $branch "
    # Running docker containers
    containers=$(("$(docker container ls 2>/dev/null | wc -l)" - 1))
    [[ 0 -lt "$containers" ]] && prompt="$prompt\uf308 $containers "
    # User @ hostname, working directory
    color="\[\e[1;34m\]"
    [[ "$UID" = "0" ]] && color="\[\e[1;33m\]"
    prompt="\[\e[1;37m\][$color\u@\h \[\e[1;36m\]\w\[\e[1;37m\]] $prompt\n"
    # Jobs
    njobs=$(jobs | wc -l)
    [[ "$njobs" != "0" ]] && prompt="$prompt\[\e[1;33m\]\uf12a$njobs "
    # Dollar sign
    prompt="$prompt\[\e[32m\]\uf155\[\e[m\] "
    # Set prompt
    export PS1="$(echo -e "$prompt")"
}
export PROMPT_COMMAND=_prompt_cmd
export PROMPT_DIRTRIM=3
