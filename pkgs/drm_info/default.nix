args_@{ lib, fetchFromGitLab, drm_info, ... }:

let
  metadata = import ./metadata.nix;
  # remove fetchFromGitLab once nixpkgs uses fetchFromGitLab for drm_info
  ignore = [ "drm_info" "fetchFromGitLab" ];
  args = lib.filterAttrs (n: _v: (!builtins.elem n ignore)) args_;
in
(drm_info.override args).overrideAttrs (_old: {
  version = metadata.rev;
  src = fetchFromGitLab {
    inherit (metadata) domain owner repo rev sha256;
  };
})

