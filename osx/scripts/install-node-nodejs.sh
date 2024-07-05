#!/usr/bin/env bash

# Strict mode: https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

# Install Node versions
nvm install stable
nvm install 18.17.0         # Kibana
nvm install 18.17.1         # Kibana
nvm install 18.18.2         # Kibana
nvm install 20.10.0         # Kibana
nvm install 20.11.1         # Kibana
nvm install 20.12.2         # Kibana
nvm install 20.13.1         # Kibana current

nvm alias default 20.13.1 && nvm use default
# nvm reinstall-packages 20.12.2
nvm ls
