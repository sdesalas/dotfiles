# ---------------------------
# ZSH BRANCH DISPLAY

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%b'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

PROMPT='%F{cyan}%1~ %F{blue}git:%F{red}(${vcs_info_msg_0_})%F{white}$ '
