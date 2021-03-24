# ----------------------------
# ENVIRONMENT VARIABLE PROFILE
# ----------------------------

export LANG=en_US.UTF-8
export EDITOR='nvim'
export PAGER='less'
export TERMINAL='alacritty -e'
export BROWSER='firefox'

# Use pip only for virtualenvs
export PIP_REQUIRE_VIRTUALENV=true

# XDG BASE DIRECTORY SPECIFICATION
# --------------------------------
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

export HISTFILE="$XDG_CACHE_HOME"/shell_hist
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1000
export HISTIGNORE='clear*'
export INPUTRC="$XDG_CONFIG_HOME"/inputrc
export LESSHISTFILE="$XDG_CACHE_HOME"/less_hist
export NVIM_LOG_FILE="$XDG_CACHE_HOME"/nvim/messages_log
export PULSE_COOKIE="$XDG_CACHE_HOME"/pulse-cookie
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc
export PYLINTHOME="$XDG_DATA_HOME"/pylint
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/pythonrc
export GRIPHOME="$XDG_CONFIG_HOME"/grip
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME"/python-eggs
export IPYTHONDIR="$XDG_CONFIG_HOME"/ipython
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export DOT_SAGE="$XDG_DATA_HOME"/sage
export MAXIMA_USERDIR="$XDG_DATA_HOME"/maxima
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export HTML_TIDY="$XDG_CONFIG_HOME"/html-tidy.conf
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
export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export ROOT_HIST=0
export JAR=/usr/share/java/jdtls/pluginsorg.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JDTLS_CONFIG=/usr/share/java/jdtls/config_linux

# Extend PATH
export PATH=$CARGO_HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Mitigate hardcoded ligthdm errorfile
export ERRFILE=/dev/null
rm --force "$HOME"/.xsession-errors* &> /dev/null

export DOTPROFILE_LOADED=1
source "$HOME/.bashrc"
