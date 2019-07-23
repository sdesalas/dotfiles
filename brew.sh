#!/bin/bash

# ------------------------------------------------------------------------------
# Check if Homebrew is installed, and install if it's not

if [[ $(command -v brew) == "" ]]; then
    echo "Homebrew :: Installing"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# ------------------------------------------------------------------------------
# Configure and update

export HOMEBREW_NO_AUTO_UPDATE=1

echo "Homebrew :: Adding taps"
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions

echo "Homebrew :: Updating"
brew update
brew upgrade

export HOMEBREW_NO_AUTO_UPDATE=0

# ------------------------------------------------------------------------------
# Install essentials

# Git
brew install git && brew link --force git
brew install git-crypt
brew install git-lfs
git lfs install

# Utils
brew install httpie
brew install jq
brew install mackup
brew install mitmproxy
brew install mtr
brew install wget

# ------------------------------------------------------------------------------
# Customize shell and terminal

# ZSH
brew install zsh
brew install antigen

# https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

# Terminal
brew cask install iterm2
brew cask install font-hack-nerd-font

# ------------------------------------------------------------------------------
# Install GUI apps

# Browsers
brew cask install firefox
brew cask install firefox-developer-edition
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install opera

# Messengers
brew cask install skype
brew cask install slack
brew cask install telegram

# Files and documents
brew cask install adobe-acrobat-reader
brew cask install commander-one
brew cask install double-commander
brew cask install google-backup-and-sync
brew cask install yandex-disk

# Misc tools
brew cask install 1password6
brew cask install airserver
brew cask install calibre
brew cask install grammarly
brew cask install notion
brew cask install numi
brew cask install pluralsight
brew cask install purevpn
brew cask install puush
brew cask install recordit
brew cask install vlc

# Torrent clients
brew cask install qbittorrent
brew cask install webtorrent
brew cask install xtorrent

# ------------------------------------------------------------------------------
# Install dev tools

# Editors and IDEs
brew cask install atom
brew cask install jetbrains-toolbox
brew cask install visual-studio-code

# Git-related stuff
brew cask install gitify
brew cask install gitkraken
brew cask install sourcetree

# Security
brew cask install gpg-suite
brew cask install suspicious-package

# Networking
brew cask install charles
brew cask install insomnia
brew cask install ngrok
brew cask install postman
brew cask install wireshark

# Containers and clouds
brew cask install docker
brew cask install google-cloud-sdk
brew install awscli
brew install aws-iam-authenticator
brew install kubernetes-helm
brew install terraform

# Misc tools
brew cask install browserstacklocal
brew cask install dash
brew cask install robo-3t

# ------------------------------------------------------------------------------
# Install Node.js

# Install NVM
if [[ $(command -v nvm) == "" ]]; then
    echo "NVM :: Installing"
    NVM_VERSION=0.34.0
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash

    echo "NVM :: Making it useable right away"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Install Node.js
nvm install stable  # latest stable version
nvm install 10.15.3 # for MSB
nvm install 8.6     # for balkan
nvm alias default stable
nvm use stable

# Install YARN
brew install yarn

# ------------------------------------------------------------------------------
# Install Java

# Not available anymore:
# brew cask install java8

# Consider using http://www.jenv.be

# ------------------------------------------------------------------------------
# Install Scala

# brew install scala
# brew install sbt

# ------------------------------------------------------------------------------
# Install Python

brew install python3

# ------------------------------------------------------------------------------
# Install Go

brew install go

# ------------------------------------------------------------------------------
# Cleanup Brew packages

brew cleanup
