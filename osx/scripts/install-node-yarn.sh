#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Make sure brew is in PATH during the script execution
eval "$(/usr/local/bin/brew shellenv)"      # Intel Mac
# eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon Mac

# Yarn is now shipped with Node and here we disable it to be able to install via brew
corepack disable # https://github.com/nodejs/corepack
brew install yarn
