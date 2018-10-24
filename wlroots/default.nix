{ self, super, pkgs, fetchFromGitHub }:

let
  meta = import ./metadata.nix;
in
  super.wlroots.overrideAttrs (old: rec {
    name = "wlroots-${meta.rev}";
    version = meta.rev;
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "wlroots";
      rev = meta.rev;
      sha256 = meta.sha256;
    };
    # TODO(maintenance): this needs to be updated as upstream changes
    # remove patches, we don't need to fix the wlroots version anymore
    patches = [];
  })

