# This file provides backward compatibility to nix < 2.4 clients
let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  inherit (lock.nodes.flake-compat.locked)
    owner
    repo
    rev
    narHash
  ;

  flake-compat = fetchTarball {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = narHash;
  };

  flake = import flake-compat { src = ./.; };

  warn = msg: builtins.trace "[1;31mwarning: ${msg}[0m";
  example = ''
    nixpkgs.overlays=[(import "''${builtins.fetchurl "https://github.com/nix-community/nixpkgs-wayland/archive/master.tar.gz"}/overlay.nix")];
  '';
  warning = ''
    change your 'nixpkgs-wayland' import statement to import 'overlay.nix' directly. example:
      ${example}'';
in
warn warning flake.defaultNix
