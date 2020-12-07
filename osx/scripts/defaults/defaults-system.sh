#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# General

# System Preferences > General > Click in the scroll bar to > Jump to the spot that's clicked
defaults write "Apple Global Domain" AppleScrollerPagingBehavior -int 1

# ------------------------------------------------------------------------------
# Dock

# System Preferences > Dock > Automatically hide and show the dock
defaults write com.apple.dock autohide -bool true

# System Preferences > Dock > Minimise windows into application icon
defaults write com.apple.dock "minimize-to-application" -bool true

# ------------------------------------------------------------------------------
# Language and region

defaults write "Apple Global Domain" AppleMeasurementUnits -string "Centimeters"
defaults write "Apple Global Domain" AppleMetricUnits -int 1
defaults write "Apple Global Domain" AppleTemperatureUnit -string "Celsius"

# ------------------------------------------------------------------------------
# Keyboard

# Keyboard > Keyboard > Touch bar shows > F1, F2, etc. Keys
defaults write com.apple.touchbar.agent PresentationModeGlobal -string functionKeys

# Keyboard > Keyboard > Press Fn key to > Show Control Strip
defaults write com.apple.touchbar.agent PresentationModeFnModes -dict functionKeys fullControlStrip

# Keyboard > Keyboard > Customise Control Strip...
defaults write com.apple.controlstrip FullCustomized -array \
"com.apple.system.group.brightness" \
"com.apple.system.mission-control" \
"com.apple.system.launchpad" \
"com.apple.system.group.keyboard-brightness" \
"com.apple.system.group.media" \
"com.apple.system.group.volume" \
"com.apple.system.do-not-disturb" \
"com.apple.system.sleep"

# ------------------------------------------------------------------------------
# Mouse

defaults write "Apple Global Domain" "com.apple.mouse.scaling" -int 1

# ------------------------------------------------------------------------------
# Trackpad

defaults write "Apple Global Domain" "com.apple.trackpad.scaling" -int 1

defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1

defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# ------------------------------------------------------------------------------
# Energy saver

defaults write com.apple.menuextra.battery ShowPercent -bool true

# ------------------------------------------------------------------------------
# Date and time

defaults write com.apple.menuextra.clock DateFormat -string "EEE d. MMM  HH:mm:ss"
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults write com.apple.menuextra.clock IsAnalog -bool false

# ------------------------------------------------------------------------------
# System menu

# System Preferences > Bluetooth > Show bluetooth in menu bar
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true

# System Preferences > Sound > Show volume in menu bar
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true

defaults write com.apple.systemuiserver menuExtras -array \
"/System/Library/CoreServices/Menu Extras/Clock.menu" \
"/System/Library/CoreServices/Menu Extras/Battery.menu" \
"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
"/System/Library/CoreServices/Menu Extras/Displays.menu" \
"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
"/System/Library/CoreServices/Menu Extras/Volume.menu"

# ------------------------------------------------------------------------------
# Finder

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show hidden files by default
# https://www.macworld.co.uk/how-to/mac-software/hidden-files-mac-3520878/
# Manually: Cmd + Shift + . (dot)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
# https://www.defaults-write.com/display-the-file-extensions-in-finder/
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
