#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Make sure brew is in PATH during the script execution
eval "$(/opt/homebrew/bin/brew shellenv)"

# Browsers
brew install --cask google-chrome               # https://www.google.com/chrome/
brew install --cask google-chrome@dev           # https://www.google.com/chrome/dev/?platform=mac&extra=devchannel
brew install --cask firefox                     # https://www.mozilla.org/en-US/firefox/new/
brew install --cask firefox@developer-edition   # https://www.mozilla.org/en-US/firefox/developer/
brew install --cask brave-browser               # https://brave.com/
brew install --cask opera                       # https://www.opera.com/
brew install --cask microsoft-edge              # https://www.microsoft.com/en-gb/edge
brew install --cask arc                         # https://arc.net/

# Communication
brew install --cask telegram                    # https://telegram.org/
# brew install --cask slack                       # https://slack.com/
# brew install --cask zoom                        # https://zoom.us/

# Files
brew install --cask commander-one               # https://commander-one.com/
brew install --cask google-drive                # https://www.google.com/drive/
brew install --cask yandex-disk                 # https://360.yandex.com/disk/download/
brew install --cask dropbox                     # https://www.dropbox.com/
brew install --cask megasync                    # https://mega.io/syncing
brew install --cask adobe-acrobat-reader        # https://get.adobe.com/reader/

# Secrets
brew install --cask bitwarden                   # https://bitwarden.com/

# Productivity
brew install --cask ticktick                    # https://ticktick.com/
brew install --cask obsidian                    # https://obsidian.md/
brew install --cask numi                        # https://numi.app/
