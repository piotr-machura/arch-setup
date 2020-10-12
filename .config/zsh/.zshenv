# ---------------------
# ZSH SHELL ENVIRONMENT
# ---------------------

export HISTFILE="$XDG_CACHE_HOME"/zsh_hist

# VIRTUALENV
# ----------

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi
export PIP_REQUIRE_VIRTUALENV=true
