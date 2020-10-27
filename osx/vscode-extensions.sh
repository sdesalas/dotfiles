#!/usr/bin/env zsh

inputfile="./vscode-extensions.txt"
extensions=$(cat ${inputfile} | grep -v "^$")

for ext in $extensions; do
    code --install-extension $ext --force
done
