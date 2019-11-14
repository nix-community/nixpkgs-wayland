let
  meta = import ./metadata.nix;
in
  builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/${meta.rev}.tar.gz";
    sha256 = meta.sha256;
  }
