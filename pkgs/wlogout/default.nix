args_@{ lib
, fetchFromGitHub
, wlogout
, ...
}:

let
  metadata = import ./metadata.nix;
  ignore = [ "wlogout" ];
  args = lib.filterAttrs (n: _: (!builtins.elem n ignore)) args_;
in
(wlogout.override args).overrideAttrs (old: {
  version = metadata.rev;
  src = fetchFromGitHub {
    inherit (metadata) owner repo rev sha256;
  };
})
