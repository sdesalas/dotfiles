#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# ------------------------------------------------------------------------------
# Install iTerm

# Ask for the administrator password upfront
sudo -v

# Make sure brew is in PATH during the script execution
eval "$(/usr/local/bin/brew shellenv)"      # Intel Mac
# eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon Mac

# Install packages
brew install --cask iterm2
brew install --cask warp

# ------------------------------------------------------------------------------
# Download iTerm2 color schemes
# https://github.com/martinlindhe/base16-iterm2

export DOWNLOADS="$HOME/Downloads/iTerm2"
export CSCHEMES_DIR="$DOWNLOADS/color-schemes"
export CSCHEMES_ZIP="$DOWNLOADS/color-schemes.zip"
export CSCHEMES_URL="https://github.com/martinlindhe/base16-iterm2/archive/master.zip"

# Cleanup previous downloads
rm -rf "$DOWNLOADS"
mkdir -p "$DOWNLOADS"

# Download new files
curl -o "$CSCHEMES_ZIP" -L "$CSCHEMES_URL"
unzip -a "$CSCHEMES_ZIP" -d "$CSCHEMES_DIR"

# ------------------------------------------------------------------------------
# Import color schemes

# iTerm -> Preferences -> Profiles -> Colors -> Color Presets -> Import
# then select the colour scheme you like.

# ------------------------------------------------------------------------------
# Set up "Nerd Fonts"

# iTerm2 -> Preferences -> Profiles -> Text -> Font -> Change Font
