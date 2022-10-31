let
  flake =import
  (
    let lock = builtins.fromJSON (builtins.readFile ./flake.lock); in
    fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
      sha256 = lock.nodes.flake-compat.locked.narHash;
    }
  )
  { src = ./.; };

  warn = msg: builtins.trace "[1;31mwarning: ${msg}[0m";
  example = ''
    nixpkgs.overlays=[(import "''${builtins.fetchurl "https://github.com/nix-community/nixpkgs-wayland/archive/master.tar.gz"}/overlay.nix")];
  '';
  warning = "change your 'nixpkgs-wayland' import statement to import 'overlay.nix' directly. example:\n  ${example}";
in
  warn warning flake.defaultNix.overlays.default
