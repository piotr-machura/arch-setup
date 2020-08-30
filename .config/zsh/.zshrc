# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Export path
export PATH=$HOME/.local/bin:$PATH

# History/suggestion settings
setopt hist_ignore_dups
export HISTFILE="$HOME"/.cache/zsh_hist
ZSH_AUTOSUGGEST_STRATEGY=(completion)
HISTSIZE=1000
SAVEHIST=1000
HISTORY_IGNORE="c|clear"

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
# Locale, title, cursor and vi-mode
export LANG=en_US.UTF-8
case $TERM in
  xterm*)
    precmd () {print -Pn "\e]0;$USER@$HOST: ${PWD/#$HOME/~}\a"}
    ;;
esac
_set_cursor() {echo -ne '\e[4 q'}
precmd_functions+=(_set_cursor)
bindkey -v

# Require virtual environment for pip install
export PIP_REQUIRE_VIRTUALENV=true

# Extract function for common compression formats
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

# Exports to match XDG base directory specification
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

export ERRFILE="$XDG_CACHE_HOME"/xsession-errors
export PYLINTHOME="$XDG_DATA_HOME"/pylint
export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/en.pws; repl $XDG_CONFIG_HOME/aspell/en.prepl;"
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
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine
export GOPATH="$XDG_DATA_HOME"/go
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh

# Load plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

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
    #go            # Go version
    )
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_DIR_TRUNC=1
SPACESHIP_DIR_LOCK_SYMBOL=" "
SPACESHIP_DIR_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_DIR_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX

SPACESHIP_VI_MODE_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_VI_MODE_INSERT=" "
SPACESHIP_VI_MODE_NORMAL=" "
SPACESHIP_VI_MODE_COLOR="green"

SPACESHIP_GIT_PREFIX=" "
SPACESHIP_GIT_SYMBOL=" " 
SPACESHIP_GIT_BRANCH_COLOR="magenta"
SPACESHIP_GIT_STATUS_COLOR="magenta"
SPACESHIP_GIT_STATUS_PREFIX=" ["
SPACESHIP_GIT_STATUS_SUFFIX="]"
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

SPACESHIP_DOCKER_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_DOCKER_SYMBOL=" "
SPACESHIP_DOCKER_COLOR="cyan"
SPACESHIP_DOCKER_CONTEXT_PREFIX=" ("
SPACESHIP_DOCKER_CONTEXT_SUFFIX=") "

SPACESHIP_VENV_SYMBOL=" "
SPACESHIP_VENV_COLOR="blue"

SPACESHIP_GOLANG_SYMBOL="ﳑ "
SPACESHIP_GOLANG_COLOR="green"

SPACESHIP_PACKAGE_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_PACKAGE_SYMBOL="ﰩ "
SPACESHIP_PACKAGE_COLOR="yellow"

autoload -U promptinit; promptinit
prompt spaceship
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
alias source_zshrc='source "$XDG_CONFIG_HOME"/zsh/.zshrc; echo "Sourced."'
alias clean_pkgdata='yay -Rns $(yay -Qdtq); yay -Scc'
