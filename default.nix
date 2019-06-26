self: pkgs:
let
waylandPkgs = rec {
  # temp
  wlroots_050     = pkgs.callPackage ./pkgs-temp/wlroots-0.5.0 {};
  wlroots_060     = pkgs.callPackage ./pkgs-temp/wlroots-0.6.0 {};

  # wlroots-related
  wlroots          = pkgs.callPackage ./pkgs/wlroots {};
  xdg-desktop-portal-wlr = pkgs.callPackage ./pkgs/xdg-desktop-portal-wlr {};
  sway             = pkgs.callPackage ./pkgs/sway {};
  swaybg           = pkgs.callPackage ./pkgs/swaybg {};
  swayidle         = pkgs.callPackage ./pkgs/swayidle {};
  swaylock         = pkgs.callPackage ./pkgs/swaylock {};
  grim             = pkgs.callPackage ./pkgs/grim {};
  slurp            = pkgs.callPackage ./pkgs/slurp {};
  mako             = pkgs.callPackage ./pkgs/mako {};
  kanshi           = pkgs.callPackage ./pkgs/kanshi {};
  oguri            = pkgs.callPackage ./pkgs/oguri {};
  waybar           = pkgs.callPackage ./pkgs/waybar {};
  wf-config        = pkgs.callPackage ./pkgs/wf-config {};
  wayfire          = pkgs.callPackage ./pkgs/wayfire {};
  #wayfire          = pkgs.callPackage ./pkgs/wayfire { wlroots = wlroots_060; };
  redshift-wayland = pkgs.callPackage ./pkgs/redshift-wayland {
    inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = pkgs.geoclue2;
  };
  waybox           = pkgs.callPackage ./pkgs/waybox {};
  wl-clipboard     = pkgs.callPackage ./pkgs/wl-clipboard {};
  wf-recorder      = pkgs.callPackage ./pkgs/wf-recorder {};
  gebaar-libinput  = pkgs.callPackage ./pkgs/gebaar-libinput {};
  i3status-rust    = pkgs.callPackage ./pkgs/i3status-rust {};

  bspwc    = pkgs.callPackage ./pkgs/bspwc { wlroots = wlroots_050; };
  wltrunk  = pkgs.callPackage ./pkgs/wltrunk { wlroots = wlroots_050; };
  glpaper  = pkgs.callPackage ./pkgs/glpaper {};
  waypipe  = pkgs.callPackage ./pkgs/waypipe {};

  wlrobs  = pkgs.callPackage ./pkgs/wlrobs {};
  wtype   = pkgs.callPackage ./pkgs/wtype {};
  cage    = pkgs.callPackage ./pkgs/cage {};

  alacritty = pkgs.callPackage ./pkgs/alacritty {
    inherit (pkgs.xorg) libXcursor libXxf86vm libXi libxcb;
    inherit (pkgs.darwin) cf-private;
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL;
  };
};
in
  waylandPkgs // { inherit waylandPkgs; }
# TODO: I think adding a waylandPkgs *against* a channel would let
#me combine build.nix in here, and make it easier for others ot use it as
#a straight pkg list instead of just the current 'waylandPkgs' overlay
