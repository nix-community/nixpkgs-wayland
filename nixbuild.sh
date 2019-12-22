#!/usr/bin/env bash

exec nix-build \
  --pure \
  --option "extra-binary-caches" "https://cache.nixos.org https://colemickens.cachix.org https://nixpkgs-wayland.cachix.org" \
  --option "trusted-public-keys" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= colemickens.cachix.org-1:oIGbn9aolUT2qKqC78scPcDL6nz7Npgotu644V4aGl4= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=" \
  --option "build-cores" "0" \
  --option "narinfo-cache-negative-ttl" "0" \
  "${@}"

#--verbose \
