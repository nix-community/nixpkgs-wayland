args_@{ stdenv, lib, fetchFromGitHub, wlroots, ... }:

let
  metadata = import ./metadata.nix;
  ignore = [ "wlroots" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(wlroots.override args).overrideAttrs(old: {
  name = "wlroots-eglstreams-${metadata.rev}";
  version = "${metadata.rev}";
  src = fetchFromGitHub {
    owner = "colemickens";
    repo = "wlroots-eglstreams";
    inherit (metadata) rev sha256;
  };
})
