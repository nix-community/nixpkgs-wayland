let
  # TODO: convert to callPackages and non-overlay style? more reliable and usable by others, but can cause more pkg dupe?
  nixosUnstable = (import (import ./nixpkgs/nixos-unstable) { overlays = [ (import ./default.nix) ]; }).waylandPkgs;
  nixpkgsUnstable = (import (import ./nixpkgs/nixpkgs-unstable) { overlays = [ (import ./default.nix) ]; }).waylandPkgs;
in
  {
    all = [ nixosUnstable nixpkgsUnstable ];
    inherit nixosUnstable nixpkgsUnstable;
  }

