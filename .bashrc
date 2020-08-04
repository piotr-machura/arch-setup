#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ...='cd ../..'
alias ....='cd ../../..'
shopt -s autocd

alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -lA --color=auto'

alias rm='rm -i'
alias mv='mv -i'
alias c='clear'
alias y=yay

# Change window title to PWD only
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'

# Starship prompt
eval "$(starship init bash)"
