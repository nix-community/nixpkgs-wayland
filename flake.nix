{
  description = "nixpkgs-wayland";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    lib-aggregate = { url = "github:nix-community/lib-aggregate"; };
    nix-eval-jobs = { url = "github:nix-community/nix-eval-jobs"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  outputs = inputs:
    let
      inherit (inputs.lib-aggregate) lib;
      inherit (inputs) self;

      waylandOverlay = final: prev:
        let
          template = { attrName, nixpkgsAttrName ? "", extra ? { }, replace ? { }, replaceInput ? { } }: import ./templates/template.nix { inherit prev attrName extra replace nixpkgsAttrName replaceInput; };
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
              extra.buildInputs = [ prev.libjack2 prev.playerctl ];
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
                wlroots_0_16 = final.wlroots;
              };
            }
            {
              attrName = "cage";
              extra.buildInputs = [ prev.xorg.xcbutilwm ];
              replaceInput = {
                wlroots = prev.wlroots_0_16;
              };
            }
            {
              attrName = "libvncserver_master";
              nixpkgsAttrName = "libvncserver";
            }
            {
              attrName = "freerdp";
              extra.buildInputs = [ prev.icu prev.SDL2 ];
            }
            {
              attrName = "wayvnc";
              nixpkgsAttrName = "wayvnc";
              extra.buildInputs = [ prev.jansson ];
            }
            {
              attrName = "xdg-desktop-portal-wlr";
              nixpkgsAttrName = "xdg-desktop-portal-wlr";
              replace.patches = [];
            }
            {
              attrName = "new-wayland-protocols";
              nixpkgsAttrName = "wayland-protocols";
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
            "wf-recorder"
            "wl-clipboard"
            "wlogout"
            "wlr-randr"
            "wofi"
            "wtype"
            "wshowkeys"
            "aml"
            "wdisplays"
            "kanshi"
            "wev"
            "lavalauncher"
            "wlsunset"
            "rootbar"
            "waypipe"
          ]
            (s: { attrName = s; }));

          waylandPkgs = genPackagesGH // rec {
            # wlroots-related
            salut = prev.callPackage ./pkgs/salut { };
            wayprompt = prev.callPackage ./pkgs/wayprompt { };
            wlvncc = prev.callPackage ./pkgs/wlvncc {
              libvncserver = final.libvncserver_master;
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
              wayland-protocols = final.new-wayland-protocols;
            };

            wlfreerdp = lib.warn "nixpkgs-wayland: 'wlfreerdp' is deprecated in favor of 'freerdp'; the 'wlfreerdp' alias will be dropped in March 2023." final.freerdp;

            # misc
            clipman = prev.callPackage ./pkgs/clipman { };
            foot = prev.callPackage ./pkgs/foot {
              inherit foot;
            };
            i3status-rust = prev.callPackage ./pkgs/i3status-rust { };
            shotman = prev.callPackage ./pkgs/shotman { };
            sirula = prev.callPackage ./pkgs/sirula { };
            # wayfire stuff
            wayfire-unstable = prev.callPackage ./pkgs/wayfire-unstable { };
          };
        in
        (waylandPkgs // { inherit waylandPkgs; });
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
            nativeBuildInputs = with pkgs_.nixpkgs; [
              nushell
              cachix
              cacert
              git
              mercurial
              ripgrep
              sd
              inputs.nix-eval-jobs.outputs.packages.${system}.default
            ];
          };

          formatter = pkgs_.nixpkgs.nixpkgs-fmt;

          bundle = pkgs_.nixpkgs.symlinkJoin {
            name = "nixpkgs-wayland-bundle";
            paths = builtins.attrValues waypkgs.waylandPkgs;
          };

          packages = (waypkgs.waylandPkgs);
        })
    // {
      # overlays have to be outside of eachSystem block
      overlay = waylandOverlay;

      overlays.default = waylandOverlay;
    };
}
