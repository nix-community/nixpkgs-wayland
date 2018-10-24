self: super:

let
  wlroots          = super.callPackage ./wlroots { inherit self super; };
  sway-beta        = super.callPackage ./sway-beta { inherit self super; };
  grim             = super.callPackage ./grim {};
  slurp            = super.callPackage ./slurp {};
  wlstream         = super.callPackage ./wlstream {};
  waybar           = super.callPackage ./waybar {};
  redshift-wayland = super.callPackage ./redshift-wayland {
    inherit (super.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = super.geoclue2;
  };

  swaypkgs = {
    inherit wlroots;
    inherit sway-beta;
    inherit grim;
    inherit slurp;
    inherit wlstream;
    inherit waybar;
    inherit redshift-wayland;
  };
in
  # also expose the list of packages as a package for
  # easy building from `build.nix`.
  swaypkgs // { inherit swaypkgs; }
