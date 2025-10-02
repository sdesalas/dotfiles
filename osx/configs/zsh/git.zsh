# ------------------------------------------------------------------------------
# Functions

echo "Loading - git.zsh"

function git_edit_config() {
  echo ">>> git config --global -e"
  git config --global -e
}

function git_push_origin() {
  echo ">>> git push --set-upstream origin $(git_current_branch) $@"
  git push --set-upstream origin $(git_current_branch) $@
}

# Pulls a new branch from a gm_remote repo.
# Example 1: git_review upstream mybranch
# Example 2: git_review upstream
# Example 3: git_review
function git_review() {
  local gr_main_branch=$(git_main_branch)
  local gr_remote=${1-origin}
  local gr_branch=${2-$gr_main_branch}
  echo ">>> git fetch ${gr_remote} ${gr_branch} && git checkout --track ${gr_remote}/${gr_branch} && git pull ${gr_remote} ${gr_branch} --tags"
  git fetch ${gr_remote} ${gr_branch} && git checkout --track ${gr_remote}/${gr_branch} && git pull ${gr_remote} ${gr_branch} --tags
}

# Updates local branch from its gm_remote counterpart.
# Example 1: git_update upstream mybranch
# Example 2: git_update upstream
# Example 3: git_update
function git_update() {
  local gu_current_branch=$(git_current_branch)
  local gu_remote=${1-origin}
  local gu_branch=${2-$gu_current_branch}
  echo ">>> git checkout ${gu_branch} && git pull ${gu_remote} ${gu_branch} --tags"
  git checkout ${gu_branch} && git pull ${gu_remote} ${gu_branch} --tags
}

# Updates local repo after merging a PR to the gm_remote repo
# Example 1: git_merged upstream mybranch
# Example 2: git_merged upstream
# Example 3: git_merged
function git_merged() {
  local gm_main_branch=$(git_main_branch)
  local gm_current_branch=$(git_current_branch)
  local gm_remote=${1-origin}
  local gm_branch=${2-$gm_current_branch}
  echo ">>> git_update ${gm_remote} ${gm_main_branch} && git_forget_branch ${gm_branch}"
  git_update ${gm_remote} ${gm_main_branch} && git_forget_branch ${gm_branch}
}

# Removes all gm_remote-tracking branches that are not also local.
# Cleans up both origin and upstream gm_remotes.
function git_forget_gm_remote_branches() {
  LOCAL_BRANCHES=$(git branch | sed 's|* |  |' | while read line; do echo $line; done | paste -s -d'|' -)
  LOCAL_BRANCHES_ESC="${LOCAL_BRANCHES//./\.}"
  LOCAL_BRANCHES_ESC="${LOCAL_BRANCHES_ESC//'/'/'\/'}"
  git branch -r | grep -E "(origin|upstream)/" | grep -Ev "(${LOCAL_BRANCHES_ESC})$" | grep -v HEAD | xargs git branch -dr
}

# Removes a specified local branch and its gm_remote-tracking branches.
# If the local one is not merged, leaves it.
function git_forget_branch() {
  echo ">>> git checkout $(git_main_branch) && (git branch -dr origin/$1 || true) && (git branch -dr upstream/$1 || true) && (git branch -d $1 || true)"
  git checkout $(git_main_branch) && (git branch -dr origin/$1 || true) && (git branch -dr upstream/$1 || true) && (git branch -d $1 || true)
}

function git_forget() {
  if [ -z "$1" ]
  then
    git_forget_gm_remote_branches
  else
    git_forget_branch "$1"
  fi
}

function git_prune() {
  echo ">>> (git remote prune origin || true) && (git remote prune upstream || true)"
  (git remote prune origin || true) && (git remote prune upstream || true)
}

# ------------------------------------------------------------------------------
# Aliases

# These are aliases to git aliases. See configs/git/.gitconfig-common.properties
# They extend/override https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git

# Check status
alias gst='git status'

# Select or create branch
alias gb='git branch'
alias gco='git checkout'
alias gcob='git checkout -b'  # create new branch
alias gcb='git checkout -b'   # create new branch

# Commit
alias gaa='git add -A && git status'                                  # stage all changes
alias gcm='git commit -m'                                             # commit
alias gam='git commit --amend --no-edit'                              # amend last commit
alias gca='git add -A && git commit --amend --no-edit'                # stage all and amend last commit
alias gct='git add -A && git commit -m "TEMP COMMIT. REBASE ME"'      # stage all and create new commit

# Push
alias gp='f() { git_push_origin $@; };f'  # push origin current branch

# Pull
alias gro='f() { git_review origin $1; };f'
alias gru='f() { git_review upstream $1; };f'
alias guo='f() { git_update origin $1; };f'
alias guu='f() { git_update upstream $1; };f'

# Undo changes
alias gundo='f() { git reset HEAD~${1:-1} --mixed && git status; };f'
alias gunstage='git reset HEAD -- . && git status'
alias gwipe='git add -A && git commit -qm "WIPE SAVEPOINT" --no-verify && git reset HEAD~1 --hard && git status'

# Delete branches
alias gmo='f() { git_merged origin $1; };f'
alias gmu='f() { git_merged upstream $1; };f'
alias gforget='f() { git_forget $1; };f'
alias gprune='git_prune'

# Misc
alias gec='git_edit_config'

# What I changed on this branch
alias glt='git log --graph --abbrev-commit --decorate --first-parent --pretty=short HEAD'

# Additional commands from Jacek
alias my_changes="git log main..HEAD --name-only --pretty=format: | sort | uniq"
alias my_changes_in_commits="git log main..HEAD --name-only"

diff_with_main() { git diff "$(git merge-base main @)" "@"; }

alias branch-files-changed="diff_with_main --name-only"
alias open-changed-files="git diff main --name-only | xargs code"

