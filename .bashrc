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
alias ping='ping -c 5'
alias htop='echo -ne "\e]0;htop\a";htop'
alias tree='tree --dirsfirst -aCI ".git|.cache|__pycache__|.venv|node_modules|target" --prune --filelimit 50'
alias ctags='ctags --recurse'
alias gdb='gdb -q'
alias rust-gdb='rust-gdb -q'

alias mkvenv='python3 -m venv .venv && echo "Created a new virtual environment at $PWD/.venv"'
alias jpnb='(jupyter notebook &>/dev/null & disown) && echo "Opened new jupyter instance in $PWD"'
alias jpkill='killall -w jupyter-notebook && echo "Shutdown all jupyter kernels"'
alias activate='source $PWD/.venv/bin/activate'
alias pkgclean='paru -Rns $(paru -Qdtq --noconfirm); paru -Scc'
alias menu-diff='vimdiff <(ls /usr/share/applications | grep ".desktop") <(ls $XDG_DATA_HOME/applications | grep ".desktop")'

# PROMPT
# ------
function _prompt_fn() {
    # Set window title
    case "$TERM" in
        xterm*) echo -ne "\e]0;\uf155 ${PWD/$HOME/'~'}\a" ;;
    esac
    # Contruct the prompt
    prompt=""
    # Running docker containers
    containers=$(("$(docker container ls 2>/dev/null | wc -l)" - 1))
    [ "$containers" -gt 0 ] && prompt="$prompt\ufc29 $containers "
    # Running jupyter notebooks
    notebooks="$(pgrep jupyter | wc -l)"
    [ "$notebooks" -gt 0 ] && prompt="$prompt\uf02d $notebooks "
    # Python virtualenv
    [ -n "$VIRTUAL_ENV" ] &&  prompt="$prompt\uf81f $(basename "$(dirname "$VIRTUAL_ENV")") "
    # Current git branch
    branch="$(git branch --show-current 2>/dev/null)"
    [ -n "$branch" ] && prompt="$prompt\uf418 $branch "
    # Jobs
    njobs=$(jobs | wc -l)
    [ "$njobs" -gt 0 ] && prompt="$prompt\[\e[1;33m\]\uf952$njobs "
    # User @ hostname, working directory
    color="\[\e[1;34m\]"
    [ "$UID" = "0" ] && color="\[\e[1;33m\]"
    prompt="\[\e[1;37m\][$color\u@\h \[\e[1;36m\]\w\[\e[1;37m\]] $prompt\n"
    # Dollar sign
    prompt="$prompt\[\e[32m\]\uf155\[\e[m\] "
    # Set prompt
    PS1="$(echo -e "$prompt")"
    export PS1
}
export PROMPT_COMMAND=_prompt_fn
export PROMPT_DIRTRIM=2

# COLORS
# ------
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;40:do=01;35:bd=40;33;01'
LS_COLORS="$LS_COLORS:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41"
LS_COLORS="$LS_COLORS:tw=30;42:ow=34;42:st=37;44:ex=01;32"
export LS_COLORS

# Load .profile
export BASHRC_LOADED=1
[ -z "$DOTPROFILE_LOADED" ] && source ~/.profile

fetch
