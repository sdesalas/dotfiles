# ------------------------------------------------------------------------------
# NVM

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ------------------------------------------------------------------------------
# Node

export NODE_OPTIONS="--max_old_space_size=8192"

# ------------------------------------------------------------------------------
# Aliases

# NPM. Extend / override https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm
alias nd="npm dev"
alias nb="npm build"
alias ns="npm start"
alias nl="npm lint"
alias nt="npm test"

# Yarn. Extend / override https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/yarn
alias yd="yarn dev"
alias ys="yarn serve"
alias yb="yarn build"
alias yst="yarn start"
alias yl="yarn lint"
alias yt="yarn test"
