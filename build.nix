let
  # import nixos-unstable
  # this is for visibility so you can see what versions of nixpkgs are prebuilt

  #nixpkgs = (import ./nixpkgs); # TODO: remove this when nixos-unstable advances and has `sway-beta`

  nixpkgs =
    if builtins.pathExists /etc/nixpkgs
    then /etc/nixpkgs
    else (import ./nixpkgs);

  pkgs = import nixpkgs {
    overlays = [ (import ./default.nix) ];
  };

in
  with pkgs; [ swaypkgs ]

