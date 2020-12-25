#!/usr/bin/env bash
set -euo pipefail
set -x

ssh-keyscan github.com >> ${HOME}/.ssh/known_hosts

git config --global user.name \
 "Cole Botkens"

git config --global user.email \
 "cole.mickens+colebot@gmail.com"

git status

# first things first, let's update our flake
nix --experimental-features 'nix-command flakes' flake update --recreate-lock-file --no-registries
(git add -A . && git commit -m "auto-update(${JOB_ID}): flake.lock") || true
