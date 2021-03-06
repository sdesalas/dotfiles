#!/usr/bin/env bash

# Many dev tools require the full Xcode.
# https://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error/17980786#17980786

# 1. Install Xcode from the App Store (or get it from https://developer.apple.com/xcode/).
# Make sure Xcode app is in the /Applications directory (NOT /Users/{user}/Applications).

# 2. Point xcode-select to the Xcode app Developer directory.
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 3. Accept the Terms and Conditions.
sudo xcodebuild -license
