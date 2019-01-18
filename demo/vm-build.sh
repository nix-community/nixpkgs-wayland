#!/usr/bin/env bash
nix-build '<nixpkgs/nixos>' \
  --argstr configuration "$PWD/configuration.nix" \
  -A vm
