#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Make sure brew is in PATH during the script execution
eval "$(/opt/homebrew/bin/brew shellenv)"

# https://www.nerdfonts.com/
brew install font-hack-nerd-font            # https://sourcefoundry.org/hack/
brew install font-meslo-lg-nerd-font
