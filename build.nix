let
  nixosUnstable = (import (import ./nixpkgs/nixos-unstable) { overlays = [ (import ./default.nix) ]; }).waylandPkgs;
in
  {
    all = [
      nixosUnstable
    ];
    inherit nixosUnstable;
  }

