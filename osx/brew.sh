#!/usr/bin/env zsh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` timestamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ------------------------------------------------------------------------------
# Check if Homebrew is installed, and install if it's not
# https://brew.sh/

if [[ $(command -v brew) == "" ]]; then
    echo "Homebrew :: Installing"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# ------------------------------------------------------------------------------
# Configure and update

export HOMEBREW_NO_AUTO_UPDATE=1

echo "Homebrew :: Adding taps"
brew tap homebrew/cask-fonts
brew tap homebrew/cask-drivers
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
brew install wget
brew install jq
brew install httpie
brew install mitmproxy
brew install mtr

# ------------------------------------------------------------------------------
# Customize shell

brew install zsh
brew install antigen

# https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

# https://github.com/zsh-users/zsh-completions/issues/433
# https://github.com/zsh-users/zsh-completions/issues/433#issuecomment-680128428
compaudit | xargs chmod g-w

# ------------------------------------------------------------------------------
# Install languages and platforms

# NVM
if [[ $(command -v nvm) == "" ]]; then
    echo "NVM :: Installing"
    NVM_VERSION=0.36.0
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash

    echo "NVM :: Making it useable right away"
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

# Node
nvm install stable
nvm install 12.18.1
nvm install 10.15.3
nvm install 8.6
nvm alias default 12.18.1
nvm use default
nvm ls

# Yarn
brew install yarn

# Misc languages
brew install go
brew install python3

# ------------------------------------------------------------------------------
# Install dev tools

brew cask install iterm2
brew cask install font-hack-nerd-font
brew cask install visual-studio-code
brew cask install jetbrains-toolbox
brew cask install typora

brew cask install gitkraken
brew cask install sourcetree
brew cask install gitify

brew cask install docker
brew cask install google-cloud-sdk
brew install awscli
brew install aws-iam-authenticator
brew install kubernetes-helm
brew install terraform

brew cask install dash
brew cask install robo-3t
brew cask install browserstacklocal
brew cask install postman
brew cask install insomnia
brew cask install charles
brew cask install wireshark
brew cask install ngrok
brew cask install gpg-suite
brew cask install suspicious-package

# ------------------------------------------------------------------------------
# Install other apps

brew cask install commander-one
brew cask install ticktick
brew cask install notion
brew cask install numi
brew cask install purevpn

# brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox
brew cask install firefox-developer-edition
brew cask install opera

brew cask install slack
brew cask install skype
brew cask install telegram

brew cask install adobe-acrobat-reader
brew cask install megasync
brew cask install 1password6
brew cask install calibre
brew cask install grammarly
brew cask install pluralsight
brew cask install puush
brew cask install qbittorrent
brew cask install recordit
brew cask install vlc
brew cask install logitech-options
brew cask install native-access
brew cask install splice

# ------------------------------------------------------------------------------
# Restore apps' configurations

# https://github.com/lra/mackup
brew install mackup
mackup restore

# ------------------------------------------------------------------------------
# Cleanup Brew packages

brew cleanup
