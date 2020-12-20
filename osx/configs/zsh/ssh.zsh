# ------------------------------------------------------------------------------
# SSH

export SSH_KEY_PATH="~/.ssh/banderror"
export SSH_KEY_PATH_PERSONAL="$HOME/.ssh/banderror"

eval "$(ssh-agent -s)"
chmod 600 $SSH_KEY_PATH_PERSONAL # https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open-error
ssh-add -K $SSH_KEY_PATH_PERSONAL
