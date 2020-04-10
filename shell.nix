let 
  pkgs  = import (builtins.fetchTarball { url = "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz"; }) {};
  cachixpkgs = import (builtins.fetchTarball { url = "https://cachix.org/api/v1/install"; }) {};
in
pkgs. stdenv.mkDerivation {
  name = "nixpkgs-wayland-devenv";

  nativeBuildInputs = with pkgs; [
    bash
    cacert
    curl
    git
    jq
    mercurial
    nix
    nix-prefetch
    openssh
    ripgrep
  ] ++ [ cachixpkgs.cachix ];

  buildInputs = with pkgs; [
    openssl
  ];
}
