args_@{ lib, fetchFromGitLab, wlroots
, hwdata
, ... }:

let
  metadata = import ./metadata.nix;
  ignore = [ "wlroots" "hwdata" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(wlroots.override args).overrideAttrs (old: {
  version = "${metadata.rev}";
  buildInputs = old.buildInputs ++ [ hwdata ];
  src = fetchFromGitLab {
    inherit (metadata) domain owner repo rev sha256;
  };
})
