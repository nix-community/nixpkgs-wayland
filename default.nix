self: super:

let
  wlroots          = super.callPackage ./wlroots { inherit self super; };
  sway-beta        = super.callPackage ./sway-beta { inherit self super; };
  grim             = super.callPackage ./grim {};
  slurp            = super.callPackage ./slurp {};
  wlstream         = super.callPackage ./wlstream {};
  waybar           = super.callPackage ./waybar {};
  redshift-wayland = super.callPackage ./redshift-wayland {};

  swaypkgs = {
    inherit wlroots;
    inherit sway-beta;
    inherit grim;
    inherit slurp;
    inherit wlstream;
    #inherit waybar;
    #inherit redshift-wayland;
  };
in
  swaypkgs // { inherit swaypkgs; }
