{
  description = "nixpkgs-wayland";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    cachix = { url = "github:nixos/nixpkgs/nixos-21.11"; };
    lib-aggregate = { url = "github:nix-community/lib-aggregate"; };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs:
    let
      inherit (inputs.lib-aggregate) lib;
      inherit (inputs) self;

      waylandOverlay = (final: prev:
        let
          template = { attrName, nixpkgsAttrName ? "", extra ? { }, replace ? { }, replaceInput ? { } }: prev.callPackage ./templates/template.nix { inherit prev attrName extra replace nixpkgsAttrName replaceInput; };
          checkMutuallyExclusive = lib.mutuallyExclusive (map (e: e.attrName) attrsExtraChangesNeeded) (map (e: e.attrName) attrsNoExtraChangesNeeded);
          genPackagesGH =
            if checkMutuallyExclusive then
              lib.listToAttrs
                (map
                  (a: {
                    name = a.attrName;
                    value = template a;
                  })
                  (attrsExtraChangesNeeded ++ attrsNoExtraChangesNeeded)
                )
            else throw "some 'attrName' value is in both attrsExtraChangesNeeded and attrsNoExtraChangesNeeded";

          # these need extra nativeBuildInputs or buildInputs or the patches cleared
          attrsExtraChangesNeeded = [
            {
              attrName = "drm_info";
              extra.nativeBuildInputs = [ prev.scdoc ];
            }
            {
              attrName = "swaylock";
              replace.patches = [ ];
            }
            {
              attrName = "grim";
              replace.patches = [ ];
            }
            {
              attrName = "waybar";
              extra.nativeBuildInputs = [ prev.libjack2 ];
            }
            {
              attrName = "gtk-layer-shell";
              extra.nativeBuildInputs = [ prev.vala ];
            }
            {
              attrName = "wl-gammactl";
              replace.postUnpack = ''
                ln -s ${prev.wlr-protocols}/share/wlr-protocols .
              '';
            }
            {
              attrName = "sway-unwrapped";
              extra.buildInputs = [ prev.xorg.xcbutilwm ];
              replaceInput = {
                pcre = prev.pcre2;
              };
            }
            {
              attrName = "cage";
              replaceInput = {
                wlroots = prev.wlroots;
              };
            }


          ];

          # these do not need changes from the package that nixpkgs has
          attrsNoExtraChangesNeeded = lib.attrValues (lib.genAttrs [
            "dunst"
            "gebaar-libinput"
            "glpaper"
            "imv"
            "mako"
            "neatvnc"
            "oguri"
            "slurp"
            "swaybg"
            "swayidle"
            "swaylock-effects"
            "wayvnc"
            "wf-recorder"
            "wl-clipboard"
            "wlogout"
            "wlr-randr"
            "wofi"
            "wtype"
            "wshowkeys"
            "aml"
            "xdg-desktop-portal-wlr"
            "wdisplays"
            "kanshi"
            "wev"
            "lavalauncher"
            "wlsunset"
            "rootbar"
            "waypipe"
          ]
            (s: { attrName = s; }));

          waylandPkgs = genPackagesGH // (rec {
            # wlroots-related
            salut = prev.callPackage ./pkgs/salut { };
            wayprompt = prev.callPackage ./pkgs/wayprompt { };
            wlvncc = prev.callPackage ./pkgs/wlvncc {
              libvncserver = libvncserver_master;
            };
            wlay = prev.callPackage ./pkgs/wlay { };
            obs-wlrobs = template {
              nixpkgsAttrName = "obs-studio-plugins.wlrobs";
              attrName = "obs-wlrobs";
            };
            # the above should actually be, but there's eval error and doing
            # 'nix build -f packages.nix' would build all packages in obs-studio-plugins
            # obs-studio-plugins = prev.obs-studio-plugins // {
            #   wlrobs = template {
            #     nixpkgsAttrName = "obs-studio-plugins.wlrobs";
            #     attrName = "wlrobs";
            #   };
            # };
            wldash = prev.callPackage ./pkgs/wldash { };
            wlroots = prev.callPackage ./pkgs/wlroots {
              inherit (prev) wlroots;
            };

            # misc
            clipman = prev.callPackage ./pkgs/clipman { };
            foot = prev.callPackage ./pkgs/foot {
              inherit foot;
            };
            i3status-rust = prev.callPackage ./pkgs/i3status-rust { };
            shotman = prev.callPackage ./pkgs/shotman { };
            sirula = prev.callPackage ./pkgs/sirula { };
            wlfreerdp = prev.callPackage ./pkgs/wlfreerdp {
              inherit (prev) libpulseaudio;
              inherit (prev.gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
            };
            # wayfire stuff
            wayfire-unstable = prev.callPackage ./pkgs/wayfire-unstable { };

            libvncserver_master = prev.callPackage ./pkgs/libvncserver_master {
              inherit (prev) libvncserver;
            };
          });
        in
        (waylandPkgs // { inherit waylandPkgs; })
      );
    in
    lib.flake-utils.eachSystem [ "aarch64-linux" "x86_64-linux" ]
      (system:
        let
          pkgsFor = pkgs: overlays:
            import pkgs {
              inherit system overlays;
              config.allowUnfree = true;
              config.allowAliases = false;
            };
          pkgs_ = lib.genAttrs (builtins.attrNames inputs) (inp: pkgsFor inputs."${inp}" [ ]);
          opkgs_ = overlays: lib.genAttrs (builtins.attrNames inputs) (inp: pkgsFor inputs."${inp}" overlays);
          waypkgs = (opkgs_ [ self.overlays.default ]).nixpkgs;
        in
        {
          devShells.default = pkgs_.nixpkgs.mkShell {
            nativeBuildInputs =
              [ ]
              ++ (with pkgs_.cachix; [ cachix ])
              ++ (with pkgs_.nixpkgs; [
                nixVersions.unstable
                nix-prefetch
                nix-build-uncached
                bash
                cacert
                curl
                git
                jq
                mercurial
                openssh
                ripgrep
                parallel
              ]);
          };

          packages = (
            waypkgs.waylandPkgs //
            {
              default = waypkgs.linkFarmFromDrvs "nixpkgs-wayland-pkgs"
                (builtins.attrValues waypkgs.waylandPkgs);
            }
          );
        })
    // {
      # overlays have to be outside of eachSystem block
      overlay = waylandOverlay;

      overlays.default = waylandOverlay;
    };
}
