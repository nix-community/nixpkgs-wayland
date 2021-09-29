let
  flake = (import (fetchTarball {
    url="https://github.com/edolstra/flake-compat/archive/12c64ca55c1014cdc1b16ed5a804aa8576601ff2.tar.gz";
    sha256="0jm6nzb83wa6ai17ly9fzpqc40wg1viib8klq8lby54agpl213w5";
  }) {
    src = ./.;
  });

  warn = msg: builtins.trace "[1;31mwarning: ${msg}[0m";
  example = ''
    nixpkgs.overlays=[(import "''${builtins.fetchurl "https://github.com/nix-community/nixpkgs-wayland/archive/master.tar.gz"}/overlay.nix")];
  '';
  warning = "change your 'nixpkgs-wayland' import statement to import 'overlay.nix' directly. example:\n  ${example}";
in
  warn warning (
    self: prev:
      flake.defaultNix.overlay self prev
  )
