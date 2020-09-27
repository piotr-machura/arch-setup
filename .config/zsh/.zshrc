# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Compinit
zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'
autoload -Uz compinit
compinit

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
alias -g ...='../..'
alias -g ....='../../..'
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

alias abiword='devour abiword'
alias parole='devour parole'
alias ristretto='devour ristretto'
alias firefox='devour firefox'
alias zathura='devour zathura'
alias jpnb='devour jupyter notebook'

# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=true
ZSH_AUTOSUGGEST_USE_ASYNC=true

#Title, cursor
precmd () {print -Pn "\e]0;${PWD/#$HOME/~} \a"}
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

SPACESHIP_GIT_PREFIX=" "
SPACESHIP_GIT_SYMBOL=" " 
SPACESHIP_GIT_BRANCH_COLOR="white"
SPACESHIP_GIT_STATUS_COLOR="white"
SPACESHIP_GIT_STATUS_PREFIX=" "
SPACESHIP_GIT_STATUS_SUFFIX=""
SPACESHIP_GIT_STATUS_UNTRACKED="?"
SPACESHIP_GIT_STATUS_ADDED="+"
SPACESHIP_GIT_STATUS_MODIFIED="~"
SPACESHIP_GIT_STATUS_RENAMED="\""
SPACESHIP_GIT_STATUS_DELETED="x"
SPACESHIP_GIT_STATUS_STASHED=""
SPACESHIP_GIT_STATUS_UNMERGED=""
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
