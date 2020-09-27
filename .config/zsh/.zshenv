# Activate the virtualenv for neovim integrated shell
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

export ERRFILE="$XDG_CACHE_HOME"/xsession-errors
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

export PYLINTHOME="$XDG_DATA_HOME"/pylint
export GRIPHOME="$XDG_CONFIG_HOME"/grip
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME"/python-eggs
export IPYTHONDIR="$XDG_CONFIG_HOME"/ipython
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export DOT_SAGE="$XDG_CONFIG_HOME"/sage

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

export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/pl.pws; repl $XDG_CONFIG_HOME/aspell/pl.prepl;"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Require virtual environment for pip install
export PIP_REQUIRE_VIRTUALENV=true

# Preffered applications
export EDITOR='vim'
export PAGER='less'
export TERMINAL='alacritty -e'
export BROWSER='firefox'
