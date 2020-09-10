#!/bin/bash

# ------------------------------------------------------------------------------
# Cleanup previous downloads

export DOWNLOADS="$HOME/Downloads/iTerm2"
rm -rf $DOWNLOADS
mkdir -p $DOWNLOADS

# ------------------------------------------------------------------------------
# Download iTerm2 color schemes
# https://github.com/martinlindhe/base16-iterm2

export CSCHEMES_DIR="$DOWNLOADS/color-schemes"
export CSCHEMES_ZIP="$DOWNLOADS/color-schemes.zip"
export CSCHEMES_URL="https://github.com/martinlindhe/base16-iterm2/archive/master.zip"

curl -o $CSCHEMES_ZIP -L $CSCHEMES_URL
unzip -a $CSCHEMES_ZIP -d $CSCHEMES_DIR

# ------------------------------------------------------------------------------
# Import color schemes

# iTerm -> Preferences -> Profiles -> Colors -> Color Presets -> Import
# then select the colour scheme you like.

# ------------------------------------------------------------------------------
# Set up "Nerd Fonts"

# Install them
brew tap homebrew/cask-fonts
brew cask install font-hack-nerd-font

# They can be found in ~/Library/Fonts:
#   $ ls -la ~/Library/Fonts
#   Hack Italic Nerd Font Complete.ttf
#   Hack Regular Nerd Font Complete.ttf
#   Hack Bold Italic Nerd Font Complete.ttf
#   Hack Bold Nerd Font Complete.ttf

# Configure iTerm
# iTerm2 -> Preferences -> Profiles -> Text -> Font -> Change Font
