#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -lA --color=auto'

alias rm='rm -i'
alias mv='mv -i'
alias c='clear'
alias y=yay
alias :wq='exit'
# Change window title to PWD only
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'

# Vi keybindings
set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-cmd-mode-string "\1\e[2 q\2"'
bind 'set vi-ins-mode-string "\1\e[6 q\2"'
# Starship prompt
eval "$(starship init bash)"
