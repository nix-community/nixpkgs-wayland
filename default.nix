self: pkgs:
let
waylandPkgs = rec {
  # temp
  scdoc-1_8        = pkgs.callPackage ./pkgs-temp/scdoc {};

  # wlroots-related
  wlroots          = pkgs.callPackage ./pkgs/wlroots {};
  sway-beta        = pkgs.callPackage ./pkgs/sway-beta { scdoc = scdoc-1_8; };
  swayidle         = pkgs.callPackage ./pkgs/swayidle {};
  swaylock         = pkgs.callPackage ./pkgs/swaylock {};
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
  i3status-rust    = pkgs.callPackage ./pkgs/i3status-rust {};
};
in
  waylandPkgs // { inherit waylandPkgs; }

