#!/usr/bin/env bash

set -x

nix --experimental-features 'nix-command flakes' \
  flake update

nix --experimental-features 'nix-command flakes' \
  flake update --update-input nixpkgs

nix --experimental-features 'nix-command flakes' \
  build .
