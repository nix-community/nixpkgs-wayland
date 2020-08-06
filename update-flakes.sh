#!/usr/bin/env bash
set -x
set -euo pipefail

cache="nixpkgs-wayland"

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

out="$(set -eu; nix --experimental-features 'nix-command flakes' --pure-eval eval --raw ".#")"
drv="$(set -euo pipefail; nix --experimental-features 'nix-command flakes' --pure-eval show-derivation "${out}" | jq -r 'to_entries[].key')"
echo -e "${drv}"

nix-build-uncached \
  --option "extra-binary-caches" "https://cache.nixos.org https://nixpkgs-wayland.cachix.org" \
  --option "trusted-public-keys" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=" \
  --option "build-cores" "0" \
  --option "narinfo-cache-negative-ttl" "0" \
  --keep-going --no-out-link ${drv} | cachix push "${cache}"

readlink -f result | cachix push "nixpkgs-wayland"

git status
git add -A .
git status
git diff-index --cached --quiet HEAD || git commit -m "flakes: update"
git push origin HEAD

