# ------------------------------------------------------------------------------
# Folders

export DEV_HOME="$HOME/Dev"
export CODE_HOME="$HOME/Code"
export DOTFILES_HOME="$CODE_HOME/dotfiles"
export DOTFILES_PRIVATE_HOME="$CODE_HOME/dotfiles-private"

# ------------------------------------------------------------------------------
# Path

export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Python 2 has been removed from MacOS, and no python binary is available now.
# Python 3 from Homebrew is a python3 binary and needs to be aliased as python.
# Here we're adding symlinks python -> python3 to the PATH.
export PATH="/usr/local/opt/python@3.9/libexec/bin:$PATH"

export PATH="$DEV_HOME/elastic-package:$PATH"

# ------------------------------------------------------------------------------
# Aliases

# https://github.com/Peltoche/lsd
# No need to set other useful aliases like ll - they are provided by oh-my-zsh
alias ls="lsd"
alias lt='ls --tree'

alias dotf="$DOTFILES_HOME"
alias dotfp="$DOTFILES_PRIVATE_HOME"
