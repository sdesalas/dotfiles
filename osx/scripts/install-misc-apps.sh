#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Make sure brew is in PATH during the script execution
eval "$(/opt/homebrew/bin/brew shellenv)"

# brew install --cask logitech-options
brew install --cask logi-options-plus       # https://www.logitech.com/en-us/software/logi-options-plus.html
brew install --cask logitune                # https://www.logitech.com/de-de/video-collaboration/software/logi-tune-software.html
brew install --cask vlc                     # https://www.videolan.org/vlc/
brew install --cask calibre                 # https://calibre-ebook.com/
brew install --cask suspicious-package      # https://www.mothersruin.com/software/SuspiciousPackage/
# brew install --cask keycastr                # https://github.com/keycastr/keycastr
# brew install --cask purevpn                 # https://www.purevpn.com/
# brew install --cask qbittorrent             # https://www.qbittorrent.org/
# brew install --cask native-access           # https://www.native-instruments.com/en/
