self: pkgs:
let
waylandPkgs = {
  # patched deps
  fmt              = pkgs.callPackage ./pkgs/fmt {};

  # wlroots-related
  wlroots          = pkgs.callPackage ./pkgs/wlroots {};
  sway-beta        = pkgs.callPackage ./pkgs/sway-beta {};
  grim             = pkgs.callPackage ./pkgs/grim {};
  slurp            = pkgs.callPackage ./pkgs/slurp {};
  mako             = pkgs.callPackage ./pkgs/mako {};
  kanshi           = pkgs.callPackage ./pkgs/kanshi {};
  wlstream         = pkgs.callPackage ./pkgs/wlstream {};
  oguri            = pkgs.callPackage ./pkgs/oguri {};
  waybar           = pkgs.callPackage ./pkgs/waybar {};
  wf-config        = pkgs.callPackage ./pkgs/wf-config {};
  wayfire          = pkgs.callPackage ./pkgs/wayfire {};
  redshift-wayland = pkgs.callPackage ./pkgs/redshift-wayland {
    inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = pkgs.geoclue2;
  };
  bspwc            = pkgs.callPackage ./pkgs/bspwc {};
  waybox           = pkgs.callPackage ./pkgs/waybox {};
  wl-clipboard     = pkgs.callPackage ./pkgs/wl-clipboard {};

  # i3-related
  wmfocus          = pkgs.callPackage ./pkgs/wmfocus {};
  i3status-rust    = pkgs.callPackage ./pkgs/i3status-rust {};

  # misc
  alacritty        = pkgs.callPackage ./pkgs/alacritty {
    inherit (pkgs.xorg) libXcursor libXxf86vm libXi;
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL;
  };
};
in
  waylandPkgs // { inherit waylandPkgs; }

