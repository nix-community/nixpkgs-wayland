args_@{ lib, fetchFromGitLab, wlroots, ... }:

let
  metadata = import ./metadata.nix;
  ignore = [ "wlroots" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(wlroots.override args).overrideAttrs (old: {
  version = "${metadata.rev}";
  src = fetchFromGitLab {
    inherit (metadata) domain owner repo rev sha256;
  };
})
