# ------------------------
# ZSH SHELL RUNTIME CONFIG
# ------------------------

[[ $- != *i* ]] && return

# ALIASES
# -------

alias -g ...='../..'
alias -g ....='../../..'

alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -lA --color=auto'
alias rm='rmtrash -I'
alias rmdir='rmdirtrash -I'
alias mv='mv -i'

alias py='python3'
alias jpnb='jupyter notebook'

alias venv='python3 -m venv .venv && echo "Created a new virtual environment at $PWD/.venv"'
alias activate='source .venv/bin/activate'
alias pkgclean='yay -Rns $(yay -Qdtq); yay -Scc'
alias htop='print -Pn "\e]0;htop\a";htop' # Change htop window title

# CLEAR ON EMPTY INPUT
# --------------------

clear-on-empty() {
    if [[ -z $BUFFER ]]
    then
        zle clear-screen
    else
        zle accept-line
    fi
}

zle -N clear-on-empty
bindkey "^M" clear-on-empty # ^M: enter keycode
bindkey -a "^M" clear-on-empty # vi normal mode

# HISTORY
# -------

setopt hist_ignore_dups
setopt share_history
HISTSIZE=1000
SAVEHIST=1000

# COMPLETION
# ----------

zstyle :compinstall filename '$ZDOTDIR/.zshrc'
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zcompdump"

# Autosuggestions plugin
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=true
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=clear-on-empty
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# THEME
# -----

#Title
precmd () {print -Pn "\e]0; ${PWD/$HOME/~}\a"}

#Cursor
_set_cursor() {echo -ne '\e[4 q'}
precmd_functions+=(_set_cursor)

# Spaceship prompt
SPACESHIP_PROMPT_DEFAULT_PREFIX=" "
SPACESHIP_PROMPT_DEFAULT_SUFFIX=""

SPACESHIP_PROMPT_ORDER=(
    dir         # Current directory
    vi_mode     # Vi mode prompt
)
SPACESHIP_RPROMPT_ORDER=(
    git         # Git branch
    venv        # Python virtual environment
    package     # Cargo/npm package
    )

SPACESHIP_DIR_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_DIR_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_DIR_LOCK_SYMBOL=" "
SPACESHIP_DIR_TRUNC=1
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_DIR_COLOR="cyan"

SPACESHIP_VI_MODE_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_VI_MODE_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_VI_MODE_INSERT=" "
SPACESHIP_VI_MODE_NORMAL=$'%{\e[1;33m%} ' # yellow escape code
SPACESHIP_VI_MODE_COLOR="green"

SPACESHIP_GIT_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_GIT_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_GIT_SYMBOL=" "
SPACESHIP_GIT_STATUS_SHOW=false
SPACESHIP_GIT_BRANCH_COLOR="white"

SPACESHIP_VENV_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_VENV_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_VENV_SYMBOL=" "
SPACESHIP_VENV_COLOR="blue"

SPACESHIP_PACKAGE_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_PACKAGE_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_PACKAGE_SYMBOL="ﰩ "
SPACESHIP_PACKAGE_COLOR="yellow"

autoload -U promptinit
promptinit
prompt spaceship

# VI MODE
# -------

bindkey "^?" backward-delete-char # ^?: backspace keycode
bindkey '^[[3~' delete-char # ^[[3: delete keycode
bindkey -a '^[[3~' delete-char # vi normal mode

eval spaceship_vi_mode_enable

# SYNTAX HIGHLIGHTING
# -------------------

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[precommand]="fg=yellow,bold"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

