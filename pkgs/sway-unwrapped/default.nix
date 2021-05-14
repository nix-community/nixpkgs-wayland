args_@{ stdenv, lib, fetchFromGitHub, sway-unwrapped, ... }:

let
  metadata = import ./metadata.nix;
  ignore = [ "sway-unwrapped" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(sway-unwrapped.override args).overrideAttrs(old: {
  name = "sway-unwrapped-${metadata.rev}";
  version = "${metadata.rev}";
  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    inherit (metadata) rev sha256;
  };
})
