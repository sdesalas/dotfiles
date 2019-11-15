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
antigen bundle git
antigen bundle command-not-found
antigen bundle osx
antigen bundle brew
antigen bundle docker
antigen bundle docker-compose
antigen bundle node
antigen bundle npm
antigen bundle nvm
antigen bundle sbt
antigen bundle scala

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
# SSH

export SSH_KEY_PATH="~/.ssh/banderror"
export SSH_KEY_PATH_BANDERROR="$HOME/.ssh/banderror"

eval "$(ssh-agent -s)"
ssh-add -K $SSH_KEY_PATH_BANDERROR

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
