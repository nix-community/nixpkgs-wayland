args_@{ stdenv, lib, fetchFromGitLab, wayland-protocols, ... }:

let
  metadata = import ./metadata.nix;
  ignore = [ "wayland-protocols" "fetchFromGitLab" ];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
(wayland-protocols.override args).overrideAttrs(old: {
  name = "wayland-protocols-${metadata.rev}";
  version = "${metadata.rev}";
  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayland";
    repo = "wayland-protocols";
    inherit (metadata) rev sha256;
  };
})
