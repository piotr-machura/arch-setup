# Activet the virtualenv for neovim integrated shell
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

# Path and locale
export PATH=$HOME/.local/bin:$PATH
export LANG=en_US.UTF-8

# Exports to match XDG base direcotry specification
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

source $ZDOTDIR/.zshrc
