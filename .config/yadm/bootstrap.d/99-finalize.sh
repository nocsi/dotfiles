#!/usr/bin/env bash

export SSH_REPO_URL="git@github.com:nocsi/dotfiles.git"

#-----------------------------------------
# * Set yadm origin url to ssh
#-----------------------------------------

echo ">>> Updating the yadm origin to ssh.."
yadm remote set-url origin "$SSH_REPO_URL"

echo "Done!"
