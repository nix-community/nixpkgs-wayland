args_@{ lib, fetchFromGitHub, i3status-rust, ...}:

let
  metadata = import ./metadata.nix;
  ignore = [ "i3status-rust" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(i3status-rust.override args).overrideAttrs(old: {
  version = metadata.rev;
  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    inherit (metadata) rev sha256;
  };
})
