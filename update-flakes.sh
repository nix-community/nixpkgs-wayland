#!/usr/bin/env bash
set -x
set -euo pipefail

git status
git add -A .
git status
if ! git diff-index --cached --quiet HEAD; then
  echo "You have local changes. boo." &> /dev/stderr
  exit 1
fi

nix --experimental-features 'nix-command flakes' \
  flake update

nix --experimental-features 'nix-command flakes' \
  flake update --update-input nixpkgs

nix --experimental-features 'nix-command flakes' \
  build .

readlink -f result | cachix push "nixpkgs-wayland"

git status
git add -A .
git status
git diff-index --cached --quiet HEAD || git commit -m "flakes: update"
git push origin HEAD

