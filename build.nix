let
  nixpkgs = (import ./nixpkgs);
  pkgs = import nixpkgs {
    overlays = [ (import ./default.nix) ];
  };

in
  pkgs.swaypkgs // { nixpkgs = {}; }

