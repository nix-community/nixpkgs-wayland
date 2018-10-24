{ self, super, pkgs, fetchFromGitHub }:

let
  meta = import ./metadata.nix;
in
  super.sway-beta.overrideAttrs (old: rec {
    name = "sway-beta-${meta.rev}";
    version = meta.rev;
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = meta.rev;
      sha256 = meta.sha256;
    };
  })

