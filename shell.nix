with (import (builtins.fetchTarball { url = "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz"; }) {});
stdenv.mkDerivation {
  name = "nixpkgs-wayland-devenv";

  nativeBuildInputs = [
    bash
    cacert
    cachix
    curl
    git
    mercurial
    nix
    nix-prefetch
    openssh
    ripgrep
  ];

  buildInputs = [
    openssl
  ];
}
