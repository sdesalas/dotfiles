#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# GitHub CLI
# https://github.com/cli/cli, https://cli.github.com/manual/
gh auth login
gh config set editor "code --wait"
gh config set -h github.com git_protocol ssh
