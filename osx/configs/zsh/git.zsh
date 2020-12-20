# ------------------------------------------------------------------------------
# Functions

# Removes all remote-tracking branches that are not also local.
# Cleans up both origin and upstream remotes.
function git_forget_remote_branches() {
    LOCAL_BRANCHES=$(git branch | sed 's|* |  |' | while read line; do echo $line; done | paste -s -d'|' -)
    LOCAL_BRANCHES_ESC="${LOCAL_BRANCHES//./\.}"
    LOCAL_BRANCHES_ESC="${LOCAL_BRANCHES_ESC//'/'/'\/'}"
    git branch -r | grep -E "(origin|upstream)/" | grep -Ev "(${LOCAL_BRANCHES_ESC})$" | grep -v HEAD | xargs git branch -dr
}

# Removes a specified local branch and its remote-tracking branches.
# If the local one is not merged, leaves it.
function git_forget_branch() {
  git checkout master && (git branch -dr origin/$1 || true) && (git branch -dr upstream/$1 || true) && (git branch -d $1 || true)
}

function git_forget() {
  if [ -z "$1" ]
  then
    git_forget_remote_branches
  else
    git_forget_branch "$1"
  fi
}

# ------------------------------------------------------------------------------
# Aliases

# These are aliases to git aliases. See configs/git/.gitconfig-common.properties
# They extend/override https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git

alias gst="git st"          # git status
alias gbr="git br"          # git branch
alias gco="git co"          # git checkout
alias gcob="git cob"        # git checkout new branch
alias gcb="git cb"          # git checkout new branch
alias gaa="git aa"          # git add all
alias gcm="git cm"          # git commit
alias gam="git amend"       # git amend
alias gca="git ca"          # git commit amend
alias gct="git ct"          # git commit temp
alias gp="git po"           # git push origin
alias gro="git revor"       # git review origin
alias gru="git revup"       # git review upstream
alias guo="git upor"        # git update origin
alias guu="git upup"        # git update upstream
alias gforget="git_forget"  # git forget branch(es)
