#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias lh='ls -d .* --color=auto'

alias c='clear'
alias y=yay
# Change window title to PWD only
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'

# Starship prompt
eval "$(starship init bash)"
