# ------------------------------------------------------------------------------
# Extending $PATH

export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# ------------------------------------------------------------------------------
# Powerlevel9k (or Powerlevel10k) ZSH theme
# https://github.com/bhilburn/powerlevel9k#prompt-customization

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs time newline status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_MODE='nerdfont-complete'

# ------------------------------------------------------------------------------
# Antigen
# https://github.com/zsh-users/antigen

# As installed via Homebrew
source /usr/local/share/antigen/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh)
# https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins-Overview
antigen bundle brew
antigen bundle command-not-found
antigen bundle docker
antigen bundle docker-compose
antigen bundle git
antigen bundle node
antigen bundle npm
antigen bundle nvm
antigen bundle osx
antigen bundle sbt
antigen bundle scala
antigen bundle yarn

# Other bundles
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# Theme
# https://github.com/romkatv/powerlevel10k
antigen theme romkatv/powerlevel10k

# Tell antigen that we're done
antigen apply

# ------------------------------------------------------------------------------
# Fix ZSH
# https://github.com/zsh-users/zsh-completions/issues/433

# compaudit | xargs chmod g-w

# ------------------------------------------------------------------------------
# SSH

export SSH_KEY_PATH="~/.ssh/banderror"
export SSH_KEY_PATH_PERSONAL="$HOME/.ssh/banderror"

eval "$(ssh-agent -s)"
chmod 600 $SSH_KEY_PATH_PERSONAL # https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open-error
ssh-add -K $SSH_KEY_PATH_PERSONAL

# ------------------------------------------------------------------------------
# Aliases

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Git. Extend / override https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
# These are aliases to git aliases. See configs/git/.gitconfig-common.properties
alias gst="git st"
alias gbr="git br"
alias gco="git co"
alias gcob="git cob"
alias gcb="git cb"
alias gaa="git aa"
alias gcm="git cm"
alias gam="git amend"
alias gca="git ca"
alias gct="git ct"
alias gu="git up"

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

# ------------------------------------------------------------------------------
# Google Cloud SDK

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

# ------------------------------------------------------------------------------
# NVM

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ------------------------------------------------------------------------------
# Node

export NODE_OPTIONS="--max_old_space_size=8192"

# ------------------------------------------------------------------------------
# Kibana and Security Solution (SIEM)
# https://github.com/elastic/siem-team/blob/master/siem-ui/dev_setup.md

# Initialize Kibana-related env variables and aliases.
# Wrapping aliases in function so they can be updated w/ version.
kibana-init() {
  export KIBANA_VERSION=${1:-master}
  export KIBANA_HOME=$HOME/Code/elastic/kibana-$KIBANA_VERSION
  export PLUGIN_NAME=security_solution
  export CASE_PLUGIN_NAME=plugins/case
  export ELASTIC_XPACK_SIEM_LISTS_FEATURE=true

  # Goto directories
  alias kbn=$KIBANA_HOME
  alias go-detections=$KIBANA_HOME/x-pack/plugins/$PLUGIN_NAME/server/lib/detection_engine/scripts
  alias go-lists=$KIBANA_HOME/x-pack/plugins/lists/server/scripts

  # Start kibana with no-base-path
  alias start-es='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=$DEV_HOME/es-data'
  alias start-kibana='cd ${KIBANA_HOME} && yarn start --no-base-path'
  alias start-kibana-es-snapshot='cd ${KIBANA_HOME} && yarn start --verbose --xpack.security.enabled=true --xpack.ingestManager.enabled=true --xpack.ingestManager.fleet.enabled=true --xpack.encryptedSavedObjects.encryptionKey=abcdefghijklmnopqrstuvwxyz123456 --host="0.0.0.0" --no-base-path'
  alias start-kibana-real-good='cd ${KIBANA_HOME} && node --max-old-space-size=8000 scripts/kibana.js --no-base-path --dev'

  # Start for endpoint
  alias start-endpoint-es='cd ${KIBANA_HOME} && yarn es snapshot --license trial -E xpack.security.authc.api_key.enabled=true -E path.data=$DEV_HOME/es-data -E network.host="0.0.0.0" -E discovery.type="single-node" -E xpack.security.enabled=true'

  # Start bootstrap process because something in package.json changed
  alias start-bootstrap='cd ${KIBANA_HOME} && yarn kbn bootstrap'

  # Start typecheck for TypeScript
  alias start-type-check='cd ${KIBANA_HOME} && node scripts/type_check.js --project x-pack/tsconfig.json'

  # Start eslint to lint for issues
  alias start-lint='cd ${KIBANA_HOME} && node scripts/eslint.js x-pack/plugins/${PLUGIN_NAME}'
  alias start-lint-all='cd ${KIBANA_HOME} && node scripts/eslint.js'
  alias start-lint-siem='cd ${KIBANA_HOME} && node scripts/eslint.js x-pack/plugins/security_solution'
  alias start-lint-case='cd ${KIBANA_HOME} && node scripts/eslint.js x-pack/plugins/case'

  # Start unit tests
  alias start-jest='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $PLUGIN_NAME'
  alias start-jest-case='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $CASE_PLUGIN_NAME'

  # Start unit tests watch
  alias start-jest-watch='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js ${PLUGIN_NAME} --watch'
  alias start-jest-watch-size='cd ${KIBANA_HOME}/x-pack && node --max-old-space-size=8192 --optimize-for-size  --max_old_space_size=8192 --optimize_for_size scripts/jest.js $PLUGIN_NAME --watch --max_new_space_size=8192'
  alias start-jest-watch-case='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $CASE_PLUGIN_NAME --watch'

  # Start unit tests coverage
  alias start-jest-coverage='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $PLUGIN_NAME --coverage'
  alias start-jest-coverage-case='cd ${KIBANA_HOME}/x-pack && node scripts/jest.js $CASE_PLUGIN_NAME --coverage'

  # Start i18n Check
  alias start-i18n-check='cd ${KIBANA_HOME} && node scripts/i18n_check --ignore-missing'
  alias start-i18n-fix='cd ${KIBANA_HOME} && node scripts/i18n_check.js --fix'

  # Optional if you're using GraphQL, start the generation of graphql
  alias start-bean-gen='cd ${KIBANA_HOME}/x-pack/plugins/$PLUGIN_NAME && node scripts/generate_types_from_graphql.js'

  # Run cyclic dependencies test
  alias start-deps-check='cd ${KIBANA_HOME}/x-pack/plugins/${PLUGIN_NAME} && node scripts/check_circular_deps.js'

  # Test all of my code at once before doing a commit
  alias start-test-all='start-type-check && start-lint && start-i18n-check && start-deps-check && start-jest'
  # alias start-test-all='start-bean-gen && start-i18n-check && start-type-check && start-lint && start-lint-case && start-jest && start-jest-case'

  # Start api integration tests
  alias start-integration='cd ${KIBANA_HOME} && node scripts/functional_tests --config x-pack/test/api_integration/config.js'

  # Start cypress
  alias start-cypress='cd ${KIBANA_HOME}/x-pack/plugins/$PLUGIN_NAME && yarn cypress:run-as-ci'
  alias start-cypress-spec='f() { cd ${KIBANA_HOME}/x-pack/plugins/$PLUGIN_NAME && yarn cypress:run-as-ci --spec "**/$1" ;};f'
  alias start-cypress-open='cd $KIBANA_HOME/x-pack/plugins/$PLUGIN_NAME && yarn cypress:open'
  alias start-cypress-run='cd $KIBANA_HOME/x-pack/plugins/$PLUGIN_NAME && yarn cypress:run'
  alias start-cypress-ci='cd $KIBANA_HOME/x-pack/plugins/$PLUGIN_NAME && yarn cypress:run-as-ci'

  # Open ES Archiver Saved Index -- e.g. es-archiver filebeat/default
  alias es-archiver='f() { cd ${KIBANA_HOME}/x-pack && node ../scripts/es_archiver edit $1/default ;};f'

  # Start Backporting a PR merged w/ master
  alias start-backport='cd ${KIBANA_HOME} && node scripts/backport'

  # Doc Building Aliases
  alias build_docs='$DEV_HOME/docs/build_docs'

  # stack-docs
  alias docbldsec='build_docs --asciidoctor --doc $DEV_HOME/stack-docs/docs/en/$PLUGIN_NAME/index.asciidoc --chunk 1'

  # kibana docs
  alias docbldkbx='build_docs --doc $KIBANA_HOME/docs/index.asciidoc --chunk 1'

  # Delete node_modules and caches
  alias start-burn-the-world='cd $KIBANA_HOME && git clean -fdx -e \.idea\/ -e config\/ && rm -rf node_modules && yarn cache clean'

  # Sync kibana
  alias sync-kibana='cd $KIBANA_HOME && git checkout master && git fetch upstream && git merge upstream/master && git push origin master'
}

kibana-go() {
  kibana-init $1
  cd ${KIBANA_HOME}
  code ${KIBANA_HOME}
}

kibana-init master
