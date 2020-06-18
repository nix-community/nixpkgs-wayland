let
  pkgs = import (import ./nixpkgs/nixos-unstable) {
    overlays = [ (import ./default.nix) ];
    system = "aarch64-linux";
  };
  excludedPackages = [
    "imv"
    "lavalauncher"
    "obs-studio"
    "obs-wlrobs"
    "wldash"
  ];
in
  builtins.removeAttrs pkgs.waylandPkgs excludedPackages

