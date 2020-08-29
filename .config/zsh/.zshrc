# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Export path
export PATH=$HOME/.local/bin:$PATH

# Histfile settings
setopt hist_ignore_dups
export HISTFILE="$HOME"/.cache/zsh_hist
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
HISTSIZE=1000
SAVEHIST=1000

# Compinit
zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'
autoload -Uz compinit
compinit

# Preffered editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
# Locale and vi-mode
export LANG=en_US.UTF-8
echo -en "\e]0;$PWD\a" #-- Set icon name and window title to string
# Change cursor shape for different vi modes.
bindkey -v

# Exports to match XDG base directory specification
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

export ERRFILE="$XDG_CACHE_HOME"/xsession-errors
export PYLINTHOME="$XDG_DATA_HOME"/pylint
export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/en.pws; repl $XDG_CONFIG_HOME/aspell/en.prepl;"
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME"/bash-completion/bash_completion
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle 
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle 
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export STARSHIP_CONFIG="$XDG_CONFIG_HOME"/starship.toml
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine
export GOPATH="$XDG_DATA_HOME"/go
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
export ZSH="$XDG_CONFIG_HOME"/zsh/oh-my-zsh


# Manual plugin load
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
autoload -U promptinit; promptinit
prompt spaceship

# Spaceship prompt
SPACESHIP_CHAR_SYMBOL="$ "
SPACESHIP_CHAR_SYMBOL_ROOT="# "
SPACESHIP_PROMPT_DEFAULT_PREFIX=" "
SPACESHIP_PROMPT_DEFAULT_SUFFIX=""

SPACESHIP_PROMPT_ORDER=(
  dir           # Current directory section
  char          # Prompt character
)
SPACESHIP_RPROMPT_ORDER=(
  vi_mode       # Insert/normal vi mode
  git           # Git section (git_branch + git_status)
  docker        # Docker section
  venv          # virtualenv section
  rust          # Rust section
  )
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_DIR_TRUNC=1
SPACESHIP_DIR_SUFFIX=" "

SPACESHIP_GIT_PREFIX=" "
SPACESHIP_GIT_SYMBOL=" " 
SPACESHIP_GIT_BRANCH_COLOR="magenta"
SPACESHIP_GIT_STATUS_COLOR="magenta"
SPACESHIP_GIT_STATUS_PREFIX=" {"
SPACESHIP_GIT_STATUS_SUFFIX="}"
SPACESHIP_GIT_STATUS_UNTRACKED="?"
SPACESHIP_GIT_STATUS_ADDED="+"
SPACESHIP_GIT_STATUS_MODIFIED="*"
SPACESHIP_GIT_STATUS_RENAMED=""
SPACESHIP_GIT_STATUS_DELETED=""
SPACESHIP_GIT_STATUS_STASHED=""
SPACESHIP_GIT_STATUS_UNMERGED="="
SPACESHIP_GIT_STATUS_AHEAD="⇡"
SPACESHIP_GIT_STATUS_BEHIND="⇣"
SPACESHIP_GIT_STATUS_DIVERGED="⇕"

SPACESHIP_DOCKER_PREFIX=$SPACESHIP_DEFAULT_PREFIX
SPACESHIP_DOCKER_SYMBOL=" "
SPACESHIP_DOCKER_COLOR="cyan"
SPACESHIP_DOCKER_CONTEXT_PREFIX=" ("
SPACESHIP_DOCKER_CONTEXT_SUFFIX=") "
SPACESHIP_VENV_SYMBOL=" "
SPACESHIP_VENV_COLOR="blue"
SPACESHIP_RUST_SYMBOL=" "
SPACESHIP_RUST_COLOR="yellow"

eval spaceship_vi_mode_enable

# ALiases
setopt autocd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -lA --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias c='clear'
alias :wq='exit'
alias activate='source env/bin/activate'
