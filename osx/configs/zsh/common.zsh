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

# ------------------------------------------------------------------------------
# Aliases

# https://github.com/Peltoche/lsd
# No need to set other useful aliases like ll - they are provided by oh-my-zsh
alias ls="lsd"
alias lt='ls --tree'

alias dotf="$DOTFILES_HOME"
alias dotfp="$DOTFILES_PRIVATE_HOME"
