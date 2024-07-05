#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Create a Code folder
mkdir -p ~/Code && cd ~/Code

# Clone dotfiles repos
cd ~/Code && git clone git@github.com:banderror/dotfiles.git
cd ~/Code && git clone git@github.com:banderror/dotfiles-private.git
cd ~/Code && ls -la

# Go to the scripts folder
cd ~/Code/dotfiles/osx/scripts
