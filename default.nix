self: super:
let
swaypkgs = {
  fmt              = self.callPackage ./fmt { inherit self super; };
  wlroots          = self.callPackage ./wlroots {};
  sway-beta        = self.callPackage ./sway-beta {};
  grim             = self.callPackage ./grim {};
  slurp            = self.callPackage ./slurp {};
  wlstream         = self.callPackage ./wlstream {};
  waybar           = self.callPackage ./waybar {};
  wf-config        = self.callPackage ./wf-config {};
  wayfire          = self.callPackage ./wayfire {};
  tablecloth       = self.callPackage ./tablecloth {};
  redshift-wayland = self.callPackage ./redshift-wayland {
    inherit (self.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = self.geoclue2;
  };
};
in
  swaypkgs // { inherit swaypkgs; }

