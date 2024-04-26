args_@{
  lib,
  fetchFromGitLab,
  wlroots,
  libdisplay-info,
  hwdata,
  lcms2,
  ...
}:

let
  metadata = import ./metadata.nix;
  ignore = [
    "wlroots"
    "hwdata"
    "libdisplay-info"
    "lcms2"
  ];
  args = lib.filterAttrs (n: _v: (!builtins.elem n ignore)) args_;
in
(wlroots.override args).overrideAttrs (old: {
  version = "${metadata.rev}";
  buildInputs = old.buildInputs ++ [
    hwdata
    libdisplay-info
    lcms2
  ];
  src = fetchFromGitLab {
    inherit (metadata)
      domain
      owner
      repo
      rev
      sha256
      ;
  };
})
