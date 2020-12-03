#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` timestamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Amend settings via the "defaults" CLI
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/defaults-system.sh"
source "$DIR/defaults-apps.sh"

# Kill affected applications
for app in "Dock" "Finder"; do
    killall "${app}" > /dev/null 2>&1
done
