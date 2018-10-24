self: super:

let
in
{
  wlroots          = super.callPackage ./wlroots { inherit self super; };
  #sway-beta        = super.callPackage ./sway-beta;
  grim             = super.callPackage ./grim {};
  slurp            = super.callPackage ./slurp {};
  waybar           = super.callPackage ./waybar {};
  #wlstream         = super.callPackage ./wlstream {};
  redshift-wayland = super.callPackage ./redshift-wayland {};
}

