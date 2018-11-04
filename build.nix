let
  overlays = [ (import ./default.nix) ];
  pkgs-unstable= import (import ./pkgs-unstable) { inherit overlays; };
  pkgs-release = import (import ./pkgs-18.09) { inherit overlays; };
in
  [
    pkgs-unstable.swaypkgs
    #pkgs-release.swaypkgs
  ]

