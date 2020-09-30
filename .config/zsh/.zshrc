# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Compinit
zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'
autoload -Uz compinit
compinit


# History/suggestion settings
setopt hist_ignore_dups
export HISTFILE="$XDG_CACHE_HOME"/zsh_hist
HISTSIZE=1000
SAVEHIST=1000
HISTORY_IGNORE="c|clear"

# Aliases
alias -g ...='../..'
alias -g ....='../../..'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -lA --color=auto'
alias rm='rm -i'
alias mv='mv -i'

alias c='clear'
alias opn='open-disowned-xdg'
alias :wq='exit'
alias :q='exit'
alias -g %zsh='$ZDOTDIR/.zshrc'

alias py='python3'
alias venv='python3 -m venv .venv && echo "Created a new virtual environment at ./.venv"'
alias activate='source .venv/bin/activate'
alias ranger='ranger_cd'
alias pkgclean='yay -Rns $(yay -Qdtq); yay -Scc'


# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=true
ZSH_AUTOSUGGEST_USE_ASYNC=true

#Title, cursor
precmd () {print -Pn "\e]0; ${PWD/#$HOME/~}\a"}
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

# Vi-mode
bindkey -v
eval spaceship_vi_mode_enable

# Syntax highlighting
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
