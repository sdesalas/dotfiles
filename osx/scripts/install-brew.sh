#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Ask for the administrator password upfront
sudo -v

# ------------------------------------------------------------------------------
# Install Homebrew -- https://brew.sh/

echo "Homebrew :: Installing"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
echo

# ------------------------------------------------------------------------------
# Update

echo "Homebrew :: Updating"
brew update
brew upgrade
brew cleanup
echo
