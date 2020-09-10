#!/bin/bash

# https://www.macworld.co.uk/how-to/mac-software/hidden-files-mac-3520878/
# Manually: Cmd + Shift + . (dot)
defaults write com.apple.Finder AppleShowAllFiles true;
killall Finder;
