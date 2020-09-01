# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Compinit
zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'
autoload -Uz compinit
compinit

# Load configuration
source $HOME/.config/zsh/exports.zsh
source $HOME/.config/zsh/extract.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/theme.zsh

# Load plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

