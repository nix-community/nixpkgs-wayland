with (import (builtins.fetchTarball { url = "https://github.com/colemickens/nixpkgs/archive/cmpkgs.tar.gz"; }) {});
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
  
  #GIT_SSL_CAINFO = "/etc/ssl/certs/ca-certificates.crt";
  #SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  #NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
}
