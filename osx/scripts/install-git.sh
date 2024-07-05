#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Make sure brew is in PATH during the script execution
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Git
brew install git
brew install git-crypt
brew install git-lfs

# Install additional CLIs
brew install gh     # https://github.com/cli/cli, https://cli.github.com/manual/
brew install hub    # https://github.com/github/hub, https://hub.github.com/

# Switch from built-in Git to the one installed via Homebrew
brew unlink git && brew link git
exec zsh -l
