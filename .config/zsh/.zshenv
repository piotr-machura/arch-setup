# ---------------------
# ZSH SHELL ENVIRONMENT
# ---------------------

export RC="$ZDOTDIR/.zshrc"
export ENV="$ZDOTDIR/.zshenv"

# VIRTUALENV
# ----------

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

export PIP_REQUIRE_VIRTUALENV=true
