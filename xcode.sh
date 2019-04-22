#!/bin/bash

# Many dev tools require the full Xcode.
# https://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error/17980786#17980786

# Prerequisites:
# 1. Install Xcode from the App Store (or get it from https://developer.apple.com/xcode/).
# 2. Accept the Terms and Conditions.
# 3. Ensure Xcode app is in the /Applications directory (NOT /Users/{user}/Applications).

# 4. Point xcode-select to the Xcode app Developer directory
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
