#!/usr/bin/env bash

# GitHub CLI
# https://github.com/cli/cli, https://cli.github.com/manual/
gh auth login
gh config set editor "code --wait"
gh config set -h github.com git_protocol ssh
