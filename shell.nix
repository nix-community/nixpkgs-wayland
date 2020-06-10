let
  pkgs = import (import ./nixpkgs/nixos-unstable/default.nix) {};
in
pkgs. stdenv.mkDerivation {
  name = "nixpkgs-wayland-devenv";

  nativeBuildInputs = with pkgs; [
    bash
    cacert
    cachix
    curl
    git
    jq
    mercurial
    nix
    nix-build-uncached
    nix-prefetch
    openssh
    ripgrep
  ];
}
