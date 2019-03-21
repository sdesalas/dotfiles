#!/bin/bash

# -----------------------------------------------------------------------------
# Check if Homebrew is installed, and install if it's not

if [[ $(command -v brew) == "" ]]; then
    echo "Homebrew :: Installing"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# -----------------------------------------------------------------------------
# Configure and update

echo "Homebrew :: Adding taps"
brew tap caskroom/versions

echo "Homebrew :: Updating"
brew update
brew upgrade

# -----------------------------------------------------------------------------
# Install CLI tools

# Git
brew install git && brew link --force git
brew install git-crypt
brew install git-lfs
git lfs install

# Utils
brew install jq
brew install mtr
brew install wget

# -----------------------------------------------------------------------------
# Install Node.js

# Install NVM
if [[ $(command -v nvm) == "" ]]; then
    echo "NVM :: Installing"
    NVM_VERSION=0.34.0
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash

    echo "NVM :: Making it useable in the current terminal session"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Install Node.js
nvm install node
nvm install 8.6
nvm alias default 8.6

# Install YARN
brew install yarn

# -----------------------------------------------------------------------------
# Install GUI apps

# Browsers
brew cask install firefox
brew cask install firefox-developer-edition
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install opera

# Terminals
brew cask install hyper
brew cask install iterm2

# Editors and IDEs
brew cask install atom
brew cask install jetbrains-toolbox
brew cask install visual-studio-code
