args_@{ stdenv, lib, fetchFromGitHub, wlogout, ... }:

let
  metadata = import ./metadata.nix;
  ignore = [ "wlogout" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(wlogout.override args).overrideAttrs(old: {
  name = "wlogout-${metadata.rev}";
  version = "${metadata.rev}";
  src = fetchFromGitHub {
    owner = "ArtsyMacaw";
    repo = "wlogout";
    inherit (metadata) rev sha256;
  };
})
