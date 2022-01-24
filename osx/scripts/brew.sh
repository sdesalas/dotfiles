#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` timestamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ------------------------------------------------------------------------------
# Check if Homebrew is installed, and install if it's not
# https://brew.sh/

if [[ $(command -v brew) == "" ]]; then
    echo "Homebrew :: Installing"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ------------------------------------------------------------------------------
# Configure and update

export HOMEBREW_NO_AUTO_UPDATE=1

echo "Homebrew :: Adding taps"
brew tap homebrew/cask-fonts
brew tap homebrew/cask-drivers
brew tap homebrew/cask-versions
brew tap elastic/tap

echo "Homebrew :: Updating"
brew update
brew upgrade

export HOMEBREW_NO_AUTO_UPDATE=0

# ------------------------------------------------------------------------------
# Install Git

brew install git && brew link --force git
brew install git-crypt
brew install git-lfs
git lfs install

# ------------------------------------------------------------------------------
# Install fonts

# https://www.nerdfonts.com/
# https://sourcefoundry.org/hack/
brew install --cask font-hack-nerd-font

# ------------------------------------------------------------------------------
# Customize shell

brew install zsh
brew install antigen

# https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/
sudo dscl . -create "/Users/$USER" UserShell /usr/local/bin/zsh

# https://github.com/zsh-users/zsh-completions/issues/433
# https://github.com/zsh-users/zsh-completions/issues/433#issuecomment-680128428
compaudit | xargs chmod g-w

# ------------------------------------------------------------------------------
# Install languages and platforms

# NVM
if [[ $(command -v nvm) == "" ]]; then
    echo "NVM :: Installing"
    NVM_VERSION=0.37.2
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash

    echo "NVM :: Making it useable right away"
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

# Node
nvm install stable
nvm install 8.6             # Balkan
nvm install 10.15.3         # MSB
nvm install 10.22.1         # Kibana
nvm install 12.18.1         # MSB
nvm install 12.19.1         # Kibana
nvm install 14.15.1         # Kibana
nvm install 14.15.2         # Kibana
nvm install 14.15.3         # Kibana
nvm install 14.15.4         # Kibana
nvm install 14.16.0         # Kibana
nvm install 14.16.1         # Kibana
nvm install 14.17.0         # Kibana
nvm install 14.17.3         # Kibana
nvm install 14.17.5         # Kibana
nvm install 14.17.6         # Kibana
nvm install 16.11.1         # Kibana
nvm install 16.13.0         # Kibana
nvm install 16.13.2         # Kibana current
nvm alias default 16.13.2
nvm use default
nvm ls

# Yarn
brew install yarn

# Misc languages
brew install go
brew install python3

# ------------------------------------------------------------------------------
# Install dev tools

brew install wget                       # ?
brew install jq                         # ?
brew install lsd                        # https://github.com/Peltoche/lsd
brew install bat                        # https://github.com/sharkdp/bat
brew install lolcat                     # https://github.com/busyloop/lolcat
brew install neofetch                   # https://github.com/dylanaraps/neofetch
brew install httpie                     # ?
brew install mitmproxy                  # ?
brew install mtr                        # ?
brew install fzf                        # https://github.com/junegunn/fzf
$(brew --prefix)/opt/fzf/install

brew install --cask iterm2              # ?

brew install --cask visual-studio-code  # ?
brew install --cask jetbrains-toolbox   # ?
brew install --cask typora              # ?

brew install --cask gitkraken           # ?
brew install --cask sourcetree          # ?
brew install --cask gitify              # ?

brew install --cask docker              # ?
brew install --cask google-cloud-sdk    # ?
brew install awscli                     # ?
brew install aws-iam-authenticator      # ?
brew install kubernetes-helm            # ?
brew install terraform                  # ?

brew install --cask dash                # ?
brew install --cask robo-3t             # ?
brew install --cask browserstacklocal   # ?
brew install --cask postman             # ?
brew install --cask insomnia            # ?
brew install --cask http-toolkit        # https://httptoolkit.tech/
brew install --cask charles             # ?
brew install --cask wireshark           # ?
brew install --cask ngrok               # ?
brew install --cask gpg-suite           # ?
brew install --cask suspicious-package  # ?

brew install elastic/tap/auditbeat-full     # https://www.elastic.co/guide/en/beats/auditbeat/current/auditbeat-installation-configuration.html
brew install elastic/tap/filebeat-full      # https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation-configuration.html
brew install elastic/tap/metricbeat-full    # https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-installation-configuration.html
brew install elastic/tap/packetbeat-full    # https://www.elastic.co/guide/en/beats/packetbeat/current/packetbeat-installation-configuration.html

# ------------------------------------------------------------------------------
# Install other apps

brew install --cask commander-one
brew install --cask ticktick
brew install --cask pomello
brew install --cask notion
brew install --cask numi
brew install --cask purevpn

brew install --cask google-chrome
brew install --cask google-chrome-canary
brew install --cask firefox
brew install --cask firefox-developer-edition
brew install --cask opera
brew install --cask microsoft-edge
brew install --cask brave-browser

brew install --cask slack
brew install --cask skype
brew install --cask telegram

brew install --cask google-backup-and-sync
brew install --cask adobe-acrobat-reader
brew install --cask megasync
brew install --cask 1password6
brew install --cask calibre
brew install --cask deepl
brew install --cask grammarly
brew install --cask pluralsight
brew install --cask puush
brew install --cask qbittorrent
brew install --cask recordit
brew install --cask keycastr                  # https://github.com/keycastr/keycastr
brew install --cask vlc
brew install --cask logitech-options
brew install --cask native-access
brew install --cask splice

# ------------------------------------------------------------------------------
# Restore apps' configurations

# https://github.com/lra/mackup
brew install mackup
# mackup restore

# ------------------------------------------------------------------------------
# Cleanup Brew packages

brew cleanup
