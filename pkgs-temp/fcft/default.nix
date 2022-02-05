args_@{ stdenv, lib, fetchgit, fcft, ... }:

let
  #metadata = import ./metadata.nix;
  metadata = rec {
    version = "3.0.1";
    rev = version;
    sha256 = "sha256-nYGXryxiJrgvSi5FZ0Cx+gt63P0o1/C3P/os5K1Ivks=";
  };
  ignore = [ "fcft" "fetchgit" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(fcft.override args).overrideAttrs(old: {
  name = "fcft-${metadata.version}";
  version = metadata.version;
  src = fetchgit {
    url = "https://codeberg.org/dnkl/fcft";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };
})
