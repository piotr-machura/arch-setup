# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Compinit
zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'
autoload -Uz compinit
compinit

# Exports to match XDG base dir spec
export ERRFILE="$XDG_CACHE_HOME"/xsession-errors
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

export PYLINTHOME="$XDG_DATA_HOME"/pylint
export GRIPHOME="$XDG_CONFIG_HOME"/grip
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME"/python-eggs
export IPYTHONDIR="$XDG_CONFIG_HOME"/ipython
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

export GOPATH="$XDG_DATA_HOME"/go

export ANDROID_SDK_HOME="$XDG_CONFIG_HOME"/android
export ANDROID_AVD_HOME="$XDG_DATA_HOME"/android
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME"/android
export ADB_VENDOR_KEY="$XDG_CONFIG_HOME"/android

export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history

export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle 
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle 
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle

export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/en.pws; repl $XDG_CONFIG_HOME/aspell/en.prepl;"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Require virtual environment for pip install
export PIP_REQUIRE_VIRTUALENV=true

# Preffered editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Preffered pager
export PAGER='less'

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

# History/suggestion settings
setopt hist_ignore_dups
export HISTFILE="$XDG_CACHE_HOME"/zsh_hist
HISTSIZE=1000
SAVEHIST=1000
HISTORY_IGNORE="c|clear"

# Aliases
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
alias :q='exit'
alias -g %='$ZDOTDIR/.zshrc'

alias py='python3'
alias venv='python3 -m venv .venv; echo "Created a new virtual environment at ./.venv"'
alias activate='source .venv/bin/activate'

alias pkgclean='yay -Rns $(yay -Qdtq); yay -Scc'

# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=true
ZSH_AUTOSUGGEST_USE_ASYNC=true

#Title, cursor
precmd () {print -Pn "\e]0;$USER@$HOST: ${PWD/#$HOME/~}\a"}
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
SPACESHIP_DIR_LOCK_SYMBOL=" "
SPACESHIP_DIR_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_DIR_SUFFIX=$SPACESHIP_PROMPT_DEFAULT_SUFFIX
SPACESHIP_DIR_TRUNC_REPO=false

SPACESHIP_VI_MODE_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_VI_MODE_INSERT=" "
SPACESHIP_VI_MODE_NORMAL=" "
SPACESHIP_VI_MODE_COLOR="green"

SPACESHIP_GIT_PREFIX=" "
SPACESHIP_GIT_SYMBOL=" " 
SPACESHIP_GIT_BRANCH_COLOR="white"
SPACESHIP_GIT_STATUS_COLOR="white"
SPACESHIP_GIT_STATUS_PREFIX=" "
SPACESHIP_GIT_STATUS_SUFFIX=""
SPACESHIP_GIT_STATUS_UNTRACKED="?"
SPACESHIP_GIT_STATUS_ADDED="+"
SPACESHIP_GIT_STATUS_MODIFIED="*"
SPACESHIP_GIT_STATUS_RENAMED=""
SPACESHIP_GIT_STATUS_DELETED=""
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

SPACESHIP_PACKAGE_PREFIX=$SPACESHIP_PROMPT_DEFAULT_PREFIX
SPACESHIP_PACKAGE_SYMBOL="ﰩ "
SPACESHIP_PACKAGE_COLOR="yellow"

autoload -U promptinit; promptinit
prompt spaceship

# Vi-mode
bindkey -v
eval spaceship_vi_mode_enable
bindkey -a '^[[3~' delete-char # Make delete key do the thing
bindkey '^[[3~' delete-char

# Syntax highlighting
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
