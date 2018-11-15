let
  pkgs = import (import ./nixpkgs/nixpkgs-unstable) {
    overlays = [ (import ./default.nix) ];
  };
in
  pkgs.waylandPkgs

