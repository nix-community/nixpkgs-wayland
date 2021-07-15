args_@{ lib, fetchFromGitHub, nwg-panel, ...}:

let
  metadata = import ./metadata.nix;
  ignore = [ "nwg-panel" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(nwg-panel.override args).overrideAttrs(old: {
  pname = "nwg-panel";
  version = "${metadata.rev}";
  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-panel";
    inherit (metadata) rev sha256;
  };
})
