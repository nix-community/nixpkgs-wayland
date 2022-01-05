args_@{ lib, fetchFromGitHub, cage, ...}:

let
  metadata = import ./metadata.nix;
  ignore = [ "cage" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(cage.override args).overrideAttrs(old: {
  pname = "cage";
  version = "${metadata.rev}";
  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = "cage";
    inherit (metadata) rev sha256;
  };
})
