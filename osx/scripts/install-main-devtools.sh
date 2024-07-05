#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Make sure brew is in PATH during the script execution
eval "$(/opt/homebrew/bin/brew shellenv)"

# Core
brew install --cask visual-studio-code  # https://code.visualstudio.com/
brew install --cask typora              # https://typora.io/
brew install --cask gitkraken           # https://www.gitkraken.com/
brew install --cask docker              # https://www.docker.com/

# HTTP and networking
brew install --cask postman             # https://www.postman.com/
brew install --cask insomnia            # https://insomnia.rest/
brew install --cask http-toolkit        # https://httptoolkit.tech/
brew install --cask charles             # https://www.charlesproxy.com/
brew install --cask wireshark           # https://www.wireshark.org/

# Documentation
brew install --cask dash                # https://kapeli.com/dash
