#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder

mkdir -p ~/Code
cd ~/Code

git clone git@github.com:banderror/dotfiles.git
git clone git@github.com:banderror/dotfiles-private.git

ls -la

cd ~/Code/dotfiles/osx
