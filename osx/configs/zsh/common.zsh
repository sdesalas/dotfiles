# ------------------------------------------------------------------------------
# Init

echo "Loading - common.zsh"

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

# Homebrew doesn't add itself to PATH out of the box
# eval "$(/usr/local/bin/brew shellenv)"      # Intel Mac
# eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon Mac

# Python 2 has been removed from MacOS, and no python binary is available now.
# Python 3 from Homebrew is a python3 binary and needs to be aliased as python.
# Here we're adding symlinks python -> python3 to the PATH.

#export PATH="/usr/local/opt/python@3.9/libexec/bin:$PATH"

export PATH="$DEV_HOME/elastic-package:$PATH"
export PATH="$HOME/.local/bin:$PATH" # <-- claude

# ------------------------------------------------------------------------------
# Aliases

# https://github.com/Peltoche/lsd
# No need to set other useful aliases like ll - they are provided by oh-my-zsh
alias ls="lsd"
alias lt='ls --tree'

alias dotf="$DOTFILES_HOME"
alias dotfp="$DOTFILES_PRIVATE_HOME"

header() {
    echo "       ▪▪▪▪▪▪▪▪▪▪▪▪ [ $@ ] ▪▪▪▪▪▪▪▪▪▪▪▪"
}

# ------------------------------------------------------------------------------
# Port forwarding 9200 to remote 'A la Carte' instances

# https://kibana-a-la-carte.kbndev.co/

portfwd() {
  if [ -z "$1" ] || [ -z "$2" ]
  then
    echo " Please enter local port and remote hostname (to forward 9200 via SSH):"
    echo " $ portfwd 9210 pr-243221-snapshots-initial-poc-option2.sdesalas.kbndev.co"
    return
  fi
  echo "Forwarding port..\n"
  echo "localhost:$1 --┐"
  echo "                 └----> ${2}:9200\n"
  sleep 2
  echo "$ ssh -N -L ${1}:localhost:9200 kibana@${2}\n"
  echo "Ctrl+C to stop"
  ssh -N -L ${1}:localhost:9200 kibana@${2}
}
