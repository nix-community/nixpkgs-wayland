self: pkgs:
let
waylandPkgs = rec {
  # wlroots-related
  cage             = pkgs.callPackage ./pkgs/cage {};
  drm_info         = pkgs.callPackage ./pkgs/drm_info {};
  gebaar-libinput  = pkgs.callPackage ./pkgs/gebaar-libinput {};
  glpaper          = pkgs.callPackage ./pkgs/glpaper {};
  grim             = pkgs.callPackage ./pkgs/grim {};
  kanshi           = pkgs.callPackage ./pkgs/kanshi {};
  mako             = pkgs.callPackage ./pkgs/mako {};
  oguri            = pkgs.callPackage ./pkgs/oguri {};
  rootbar          = pkgs.callPackage ./pkgs/rootbar {};
  slurp            = pkgs.callPackage ./pkgs/slurp {};
  sway             = pkgs.callPackage ./pkgs/sway {};
  swaybg           = pkgs.callPackage ./pkgs/swaybg {};
  swayidle         = pkgs.callPackage ./pkgs/swayidle {};
  swaylock         = pkgs.callPackage ./pkgs/swaylock {};
  waybar           = pkgs.callPackage ./pkgs/waybar {};
  waybox           = pkgs.callPackage ./pkgs/waybox {};
  waypipe          = pkgs.callPackage ./pkgs/waypipe {};
  wdisplays        = pkgs.callPackage ./pkgs/wdisplays {};
  wev              = pkgs.callPackage ./pkgs/wev {};
  wf-recorder      = pkgs.callPackage ./pkgs/wf-recorder {};
  wlay             = pkgs.callPackage ./pkgs/wlay {};
  wlrobs           = pkgs.callPackage ./pkgs/wlrobs {};
  wl-clipboard     = pkgs.callPackage ./pkgs/wl-clipboard {};
  wldash           = pkgs.callPackage ./pkgs/wldash {};
  wlroots          = pkgs.callPackage ./pkgs/wlroots {};
  wlr-randr        = pkgs.callPackage ./pkgs/wlr-randr {};
  wofi             = pkgs.callPackage ./pkgs/wofi {};
  wtype            = pkgs.callPackage ./pkgs/wtype {};
  xdg-desktop-portal-wlr = pkgs.callPackage ./pkgs/xdg-desktop-portal-wlr {};

  # patch wlroots stable with the RDP-HEAD patch
  wlroots-stable = pkgs.wlroots.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace "backend/rdp/peer.c" \
       --replace \
         "nsc_context_set_pixel_format(context->nsc_context, PIXEL_FORMAT_BGRA32);" \
         "return nsc_context_set_parameters(context->nsc_context, NSC_COLOR_FORMAT, PIXEL_FORMAT_BGRA32);"
    '';
  });
  
  # wxrc
  wxrc = pkgs.callPackage ./pkgs/wxrc {
    openxr-loader = pkgs.callPackage ./pkgs-temp/openxr-loader-wxrc {};
  };
  
  # temporary, will upstream to nixpkgs
  # temporary-temporarily disabled to test my nixpkgs change in local nixpkgs
  cglm = pkgs.callPackage ./pkgs-temp/cglm {};

  # misc
  redshift-wayland = pkgs.callPackage ./pkgs/redshift-wayland {
    inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = pkgs.geoclue2;
  };
  freerdp = pkgs.callPackage ./pkgs/freerdp {
    inherit (pkgs) libpulseaudio;
    inherit (pkgs.gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };
  
  # i3 related
  i3status-rust    = pkgs.callPackage ./pkgs/i3status-rust {};
  
  # wayfire stuff
  wf-config        = pkgs.callPackage ./pkgs/wf-config {};
  wayfire          = pkgs.callPackage ./pkgs/wayfire {
    wlroots = pkgs.callPackage ./pkgs-temp/wlroots-wf {};
  };

  # bspwc/wltrunk stuff
  bspwc    = pkgs.callPackage ./pkgs/bspwc { wlroots = wlroots-stable; };
  wltrunk  = pkgs.callPackage ./pkgs/wltrunk { wlroots = wlroots-stable; };  
};
in
  waylandPkgs // { inherit waylandPkgs; }
