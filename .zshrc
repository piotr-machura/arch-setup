# ------------------------
# ZSH SHELL RUNTIME CONFIG
# ------------------------

[[ -z $DOTPROFILE_LOADED ]] && source "$HOME/.profile"
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
alias venv='python3 -m venv .venv && echo "Created a new virtual environment at $PWD/.venv"'
alias activate='source .venv/bin/activate'
alias pkgclean='paru -Rns $(paru -Qdtq); paru -Scc'
alias htop='print -Pn "\e]0;htop\a";htop' # Change htop window title

# CLEAR ON EMPTY INPUT
# --------------------

clear-on-empty() {
    [[ -z $BUFFER ]] && zle clear-screen
    [[ -z $BUFFER ]] || zle accept-line
}

zle -N clear-on-empty
bindkey "^M" clear-on-empty # ^M: enter keycode
bindkey -a "^M" clear-on-empty # vi normal mode

# HISTORY
# -------

setopt hist_ignore_dups
HISTSIZE=1000
SAVEHIST=2000

# COMPLETION
# ----------

zstyle :compinstall filename "$HOME/.zshrc"
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
_term_title () {print -Pn "\e]0; ${PWD/$HOME/~}\a"}
precmd_functions+=(_term_title)

# Cursors for vi mode
function _cursor_beam { echo -ne '\e[5 q' }
function _cursor_block { echo -ne '\e[1 q' }

function zle-keymap-select {
    case "${KEYMAP}" in
        main|viins)
            _cursor_beam
        ;;
        vicmd)
            _cursor_block
        ;;
    esac
    # Reset prompt on mode change
    zle reset-prompt ; zle -R
}
zle -N zle-keymap-select

# Default to beam cursor
precmd_functions+=(_cursor_beam)

# Spaceship prompt
SPACESHIP_PROMPT_ORDER=(
    dir         # Current directory
    vi_mode     # Vi mode prompt
)
SPACESHIP_RPROMPT_ORDER=(
    git         # Git branch
    venv        # Python virtual environment
    jobs        # Currently running jobs
)

SPACESHIP_PROMPT_DEFAULT_PREFIX=" "
SPACESHIP_PROMPT_DEFAULT_SUFFIX=""

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
SPACESHIP_VI_MODE_NORMAL=$'%{\e[33m%} ' # yellow escape code
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

SPACESHIP_JOBS_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_VENV_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_JOBS_SYMBOL="O "
SPACEHISP_JOBS_COLOR="yellow"

autoload -U promptinit
promptinit
prompt spaceship

# VI MODE
# -------

bindkey -v
bindkey "^?" backward-delete-char # ^?: backspace keycode
bindkey '^[[3~' delete-char # ^[[3: delete keycode
bindkey -a '^[[3~' delete-char # vi normal mode

KEYTIMEOUT=1 # Reduce the delay between keymap switches

# SYNTAX HIGHLIGHTING
# -------------------

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
ZSH_HIGHLIGHT_STYLES[precommand]="fg=yellow,bold"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

