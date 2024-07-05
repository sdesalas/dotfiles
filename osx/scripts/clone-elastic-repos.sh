#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Create a base folder
mkdir -p ~/Code/elastic && cd ~/Code/elastic

# Clone https://github.com/elastic/kibana
cd ~/Code/elastic && git clone --single-branch --branch=main git@github.com:banderror/kibana.git kibana-main
cd ~/Code/elastic && git clone --single-branch --branch=main git@github.com:banderror/kibana.git kibana-pr1
cd ~/Code/elastic && git clone --single-branch --branch=main git@github.com:banderror/kibana.git kibana-pr2
cd ~/Code/elastic/kibana-main && git remote add upstream git@github.com:elastic/kibana.git
cd ~/Code/elastic/kibana-pr1 && git remote add upstream git@github.com:elastic/kibana.git
cd ~/Code/elastic/kibana-pr2 && git remote add upstream git@github.com:elastic/kibana.git

# Clone https://github.com/elastic/security-docs
cd ~/Code/elastic && git clone --single-branch --branch=main git@github.com:banderror/security-docs.git
cd ~/Code/elastic/security-docs && git remote add upstream git@github.com:elastic/security-docs.git

# Clone https://github.com/elastic/support-diagnostics
cd ~/Code/elastic && git clone --single-branch --branch=main git@github.com:banderror/support-diagnostics.git
cd ~/Code/elastic/support-diagnostics && git remote add upstream git@github.com:elastic/support-diagnostics.git

# Clone https://github.com/elastic/security-team
cd ~/Code/elastic && git clone --single-branch --branch=main git@github.com:elastic/security-team.git

# Clone https://github.com/elastic/kibana-operations
cd ~/Code/elastic && git clone --single-branch --branch=main git@github.com:elastic/kibana-operations.git

# Go to the base folder
cd ~/Code/elastic && ls -la
