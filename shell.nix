with (import (builtins.fetchTarball { url = "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz"; }) {});
stdenv.mkDerivation {
  name = "nixpkgs-wayland-devenv";

  nativeBuildInputs = [
    bash
    cacert
    cachix
    curl
    mercurial
    nix
    openssh
    gitAndTools.gitFull
    gitAndTools.hub
    ripgrep
  ];

  buildInputs = [
    openssl
  ];
}
