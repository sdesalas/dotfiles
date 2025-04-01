#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Make sure brew is in PATH during the script execution
eval "$(/usr/local/bin/brew shellenv)"      # Intel Mac
# eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon Mac

# Languages and platforms
brew install go
brew install python3

# Basic CLI tools
brew install wget                       # https://www.gnu.org/software/wget/
brew install jq                         # https://jqlang.github.io/jq/
brew install lsd                        # https://github.com/Peltoche/lsd
brew install bat                        # https://github.com/sharkdp/bat
brew install busyloop/tap/envcat        # https://github.com/busyloop/envcat
brew install fzf                        # https://github.com/junegunn/fzf
brew install hey                        # https://github.com/rakyll/hey
brew install httpie                     # https://httpie.io/cli
brew install mitmproxy                  # https://mitmproxy.org/
brew install mtr                        # https://www.bitwizard.nl/mtr/
brew install pandoc                     # https://pandoc.org/index.html

# Cloud-native CLI tools
brew install vault                      # https://www.vaultproject.io/
brew install terraform                  # https://www.terraform.io/
# brew install google-cloud-sdk           # https://cloud.google.com/sdk/
# brew install awscli                     # ?
# brew install aws-iam-authenticator      # ?
# brew install kubernetes-helm            # ?

# Google Cloud SDK
# gcloud components list
# gcloud components update
# gcloud components install kubectl
# gcloud components list
