# ------------------------------------------------------------------------------
# Base folders

export DEV_HOME="$HOME/Dev"
export CODE_HOME="$HOME/Code"
export DOTFILES_HOME="$CODE_HOME/dotfiles"

# ------------------------------------------------------------------------------
# Modules

DIR="$DOTFILES_HOME/osx/configs/zsh"

source "$DIR/main.zsh"
source "$DIR/ssh.zsh"
source "$DIR/git.zsh"
source "$DIR/gcloud.zsh"
source "$DIR/node.zsh"
source "$DIR/elastic.zsh"
