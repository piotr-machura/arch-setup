# -------------------------------
# BASH INTERACTIVE SESSION CONFIG
# -------------------------------

[[ $0 != *bash ]] && return
[[ $- != *i* ]] && return

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
    # Set window title
    title=""
    [[ -z "$SSH_CONNECTION" ]] || title="$USER@${HOSTNAME%%.*}: "
    title="\uf155 $title${PWD/$HOME/'~'}"
    echo -ne "\e]0;$title\a"
    # Contruct the prompt
    prompt=""
    # Python virtualenv
    venv=""
    [[ -z "$VIRTUAL_ENV" ]] || venv="$(basename "$(dirname "$VIRTUAL_ENV")")"
    [[ -z "$venv" ]] || [[ -z "$prompt" ]] || prompt="$prompt "
    [[ -z "$venv" ]] || prompt="$prompt\uf81f $venv"
    # Current git branch
    branch="$(git branch --show-current 2>/dev/null)"
    [[ -z "$branch" ]] || [[ -z "$prompt" ]] || prompt="$prompt "
    [[ -z "$branch" ]] || prompt="$prompt\uf418 $branch"
    # Add brackets around special info (if there is any)
    [[ -z "$prompt" ]] || prompt="\[\e[1;37m\]($prompt\[\e[1;37m\]) "
    # User @ hostname, working directory
    u_host_cwd="\[\e[1;37m\][\[\e[1;34m\]\u@\h\[\e[1;37m\]: \[\e[1;36m\]\W\[\e[1;37m\]] "
    # Add newline if space is at a premium
    [[ $COLUMNS -ge 70 ]] || prompt="$u_host_cwd$prompt\n"
    [[ $COLUMNS -lt 70 ]] || prompt="$prompt$u_host_cwd"
    # Jobs
    njobs=$(jobs | wc -l)
    [[ "$njobs" = "0" ]] || prompt="$prompt\[\e[1;33m\]\uf12a$njobs"
    # Newline if space is at a premium and dollar sign
    prompt="$prompt\[\e[32m\]\uf155\[\e[m\] "
    # Set prompt
    export PS1="$(echo -e "$prompt")"
}

# VI MODE
# -------
set -o vi
bind 'set keyseq-timeout 10'
# Cursor for insert/normal mode
bind 'set show-mode-in-prompt on'
bind 'set vi-cmd-mode-string "\1\e[2 q\2"'
bind 'set vi-ins-mode-string "\1\e[6 q\2"'
# Clear screen with CTRL-L
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# HISTORY AND COMPLETION
# ----------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1000
export HISTIGNORE='clear*,cls'
bind "TAB:menu-complete"
bind '"\e[Z":menu-complete-backward' # Shift-tab
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"
