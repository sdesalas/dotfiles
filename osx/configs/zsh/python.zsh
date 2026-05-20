# ------------------------------------------------------------------------------
# Init

echo "Loading - python.zsh"

# ------------------------------------------------------------------------------
# Pyenv setup

export PATH="$HOME/.pyenv/shims:${PATH}" # <-- python

eval "$(pyenv init --path)"

echo "Using $(python --version)"