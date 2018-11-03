let
  overlays = [ (import ./default.nix) ];
  pkgs-unstable= import (import ./nixpkgs-nixos-unstable) { inherit overlays; };
  pkgs-release = import (import ./nixpkgs-nixos-18.09) { inherit overlays; };
in
  [
    pkgs-unstable.swaypkgs
    pkgs-release.swaypkgs
  ]

