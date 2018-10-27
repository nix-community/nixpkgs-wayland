self: pkgs:
let
swaypkgs = {
  # patched deps
  fmt              = pkgs.callPackage ./fmt {};

  # wlroots-related
  wlroots          = pkgs.callPackage ./wlroots {};
  sway-beta        = pkgs.callPackage ./sway-beta {};
  grim             = pkgs.callPackage ./grim {};
  slurp            = pkgs.callPackage ./slurp {};
  mako             = pkgs.callPackage ./mako {};
  kanshi           = pkgs.callPackage ./kanshi {};
  wlstream         = pkgs.callPackage ./wlstream {};
  oguri            = pkgs.callPackage ./oguri {};
  waybar           = pkgs.callPackage ./waybar {};
  wf-config        = pkgs.callPackage ./wf-config {};
  wayfire          = pkgs.callPackage ./wayfire {};
  redshift-wayland = pkgs.callPackage ./redshift-wayland {
    inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = pkgs.geoclue2;
  };
  bspwc            = pkgs.callPackage ./bspwc {};
  tablecloth       = pkgs.callPackage ./tablecloth {};

  # i3-related
  wmfocus          = pkgs.callPackage ./wmfocus {};
  i3status-rust    = pkgs.callPackage ./i3status-rust {};

  # misc
  ripasso          = self.callPackage ./ripasso {};
};
in
  swaypkgs // { inherit swaypkgs; }

