# ------------------------
# ZSH SHELL RUNTIME CONFIG
# ------------------------
# Note: this is only sourced in interactive sessions

[[ $- != *i* ]] && return

# ALIASES
# -------

alias -g ...='../..'
alias -g ....='../../..'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -lA --color=auto'
alias rm='rm -i'
alias mv='mv -i'

alias c='clear'
alias opn='mimeopen-many'
alias :wq='exit'
alias :q='exit'
alias -g %rc='$ZDOTDIR/.zshrc'
alias -g %env='$ZDOTDIR/.zshenv'

alias py='python3'
alias pg='less'
alias venv='python3 -m venv .venv && echo "Created a new virtual environment at ./.venv"'
alias activate='source .venv/bin/activate'
alias ranger='ranger_cd'
alias pkgclean='yay -Rns $(yay -Qdtq); yay -Scc'
alias jpnb='jupyter notebook'

# HISTORY
# -------

setopt hist_ignore_dups
export HISTFILE="$XDG_CACHE_HOME"/zsh_hist
HISTSIZE=1000
SAVEHIST=1000
HISTORY_IGNORE="c|clear"

# COMPLETION
# ----------

zstyle :compinstall filename '$ZDOTDIR/.zshrc'
autoload -Uz compinit
compinit

# Autosuggestions plugin
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=true
ZSH_AUTOSUGGEST_USE_ASYNC=true

# THEME
# -----

#Title
precmd () {print -Pn "\e]0; ${PWD/#$HOME/~}\a"}

#Cursor
_set_cursor() {echo -ne '\e[4 q'}
precmd_functions+=(_set_cursor)

# Spaceship prompt
SPACESHIP_PROMPT_DEFAULT_PREFIX=" "
SPACESHIP_PROMPT_DEFAULT_SUFFIX=""

SPACESHIP_PROMPT_ORDER=(
    dir           # Current directory section
    vi_mode       # Insert/normal vi mode
)
SPACESHIP_RPROMPT_ORDER=(
    git           # Git section (git_branch + git_status)
    docker        # Docker section
    venv          # Python virtual environment
    package       # Cargo/npm package
    )
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_DIR_TRUNC=1
SPACESHIP_DIR_LOCK_SYMBOL="  "
SPACESHIP_DIR_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_DIR_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_DIR_TRUNC_REPO=false

SPACESHIP_VI_MODE_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_VI_MODE_INSERT=" "
SPACESHIP_VI_MODE_NORMAL=" "
SPACESHIP_VI_MODE_COLOR="green"

SPACESHIP_GIT_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_GIT_SYMBOL=" " 
SPACESHIP_GIT_BRANCH_COLOR="white"
SPACESHIP_GIT_STATUS_SHOW=false

SPACESHIP_DOCKER_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_DOCKER_SYMBOL=" "
SPACESHIP_DOCKER_COLOR="cyan"
SPACESHIP_DOCKER_CONTEXT_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_DOCKER_CONTEXT_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX

SPACESHIP_VENV_SYMBOL=" "
SPACESHIP_VENV_COLOR="blue"

SPACESHIP_PACKAGE_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_PACKAGE_SYMBOL="ﰩ "
SPACESHIP_PACKAGE_COLOR="yellow"

autoload -U promptinit; promptinit
prompt spaceship

# VI MODE
# -------

bindkey -v
eval spaceship_vi_mode_enable

# SYNTAX HIGHLIGHTING
# -------------------

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
