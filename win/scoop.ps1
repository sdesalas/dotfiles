# https://scoop.sh/
# Main: https://github.com/ScoopInstaller/Main/tree/master/bucket
# Extra: https://github.com/lukesampson/scoop-extras/tree/master/bucket
# More: https://github.com/ScoopInstaller/Awesome

# Install Scoop
iwr -useb get.scoop.sh | iex

# Add buckets
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts

# Install apps
scoop install 7zip
scoop install vscode
scoop install googlechrome
scoop install firefox-developer
scoop install opera
scoop install slack
scoop install telegram
scoop install totalcommander
scoop install gitkraken

# Set up Node
scoop install nvm
refreshenv

nvm install 8.6
nvm install 10.15.3
nvm install 12.18.1
nvm use 12.18.1

scoop install yarn

# Set up Google Cloud SDK
scoop install gcloud
gcloud init
gcloud auth configure-docker

# Customize terminal
scoop install Hack-NF
scoop install concfg
concfg import material-palenight --non-interactive
concfg clean
