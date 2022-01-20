args_@{ lib, fetchFromGitHub, i3status-rust, lm_sensors, ... }:

let
  metadata = import ./metadata.nix;
  ignore = [ "i3status-rust" "lm_sensors" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
  newsrc = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    inherit (metadata) rev sha256;
  };
in
(i3status-rust.override args).overrideAttrs(old: {
  version = metadata.rev;
  src = newsrc;

  buildInputs = old.buildInputs ++ [ lm_sensors ];

  cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
    src = newsrc;
    outputHash = metadata.cargoSha256;
  });
})
