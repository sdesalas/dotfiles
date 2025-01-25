#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# ------------------------------------------------------------------------------
# Install

# Ask for the administrator password upfront
sudo -v

# Make sure brew is in PATH during the script execution
eval "$(/usr/local/bin/brew shellenv)"      # Intel Mac
# eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon Mac

# Install packages
brew install zsh
brew install antigen
brew install powerlevel10k      # https://github.com/romkatv/powerlevel10k

# ------------------------------------------------------------------------------
# Configure

# Switch from built-in Zsh to the one installed via Homebrew
# https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
sudo dscl . -create "/Users/$USER" UserShell /usr/local/bin/zsh

# https://github.com/zsh-users/zsh-completions/issues/433
# https://github.com/zsh-users/zsh-completions/issues/433#issuecomment-680128428
compaudit | xargs chmod g-w

# Reload terminal
exec zsh -l
