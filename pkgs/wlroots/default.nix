args_@{ lib
, fetchFromGitLab
, wlroots
, libdisplay-info
, hwdata
, fetchpatch
, ...
}:

let
  metadata = import ./metadata.nix;
  ignore = [ "wlroots" "hwdata" "libdisplay-info" ];
  args = lib.filterAttrs (n: _v: (!builtins.elem n ignore)) args_;
in
(wlroots.override args).overrideAttrs (old: {
  version = "${metadata.rev}";
  buildInputs = old.buildInputs ++ [ hwdata libdisplay-info ];
  src = fetchFromGitLab {
    inherit (metadata) domain owner repo rev sha256;
  };
  patches =
    let
      conflicting-patch = (fetchpatch {
        name = "tinywl-fix-wlroots-dependency-constraint-in-Makefile.patch";
        url = "https://gitlab.freedesktop.org/wlroots/wlroots/-/commit/fe53ec693789afb44c899cad8c2df70c8f9f9023.patch";
        hash = "sha256-wU62hXgmsAyT5j/bWeCFBkvM9cYjUntdCycQt5HAhb8=";
      });
    in
    lib.remove conflicting-patch old.patches;
})
