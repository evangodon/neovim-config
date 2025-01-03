#!/bin/sh

last_commit_date=$(git log -1 --format=%cd --date=short)
current_date=$(date +"%F")

# Fetch remote changes
git fetch origin main

# Compare local and remote master branches
local_commit=$(git rev-parse main)
remote_commit=$(git rev-parse origin/main)

# Check if the local branch is behind
if [ "$local_commit" != "$remote_commit" ] && git rev-list --left-right --count main...origin/main | grep -q '0[[:space:]]'; then
  echo "Your local branch is behind the remote branch. Please pull the changes first."
  exit 1
fi

if [ "$last_commit_date" != "$current_date" ]; then
  git add .
  git commit -m "Save on $current_date"
  git push origin main
  exit 0
fi

git add .
git commit --amend --no-edit

read -p "Do you want to force push to origin/main? (y/n): " confirm

if [ "$confirm" = "y" ]; then
    # Force push to the remote repository
    git push --force origin main 
else
    echo "Push aborted."
fi

