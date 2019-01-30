let
  pkgs = import (import ./nixpkgs/nixos-unstable) {
    overlays = [ (import ./default.nix) ];
  };
in
  pkgs.waylandPkgs
