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
          waylandPkgs = rec {
            # wlroots-related
            cage = prev.callPackage ./pkgs/cage {
              inherit (prev) wlroots;
            };
            drm_info = prev.callPackage ./pkgs/drm_info { };
            gebaar-libinput = prev.callPackage ./pkgs/gebaar-libinput { };
            glpaper = prev.callPackage ./pkgs/glpaper { };
            grim = prev.callPackage ./pkgs/grim { };
            kanshi = prev.callPackage ./pkgs/kanshi { };
            imv = prev.callPackage ./pkgs/imv {
              inherit (prev) imv;
            };
            lavalauncher = prev.callPackage ./pkgs/lavalauncher { };
            mako = prev.callPackage ./pkgs/mako { };
            oguri = prev.callPackage ./pkgs/oguri { };
            rootbar = prev.callPackage ./pkgs/rootbar { };
            salut = prev.callPackage ./pkgs/salut { };
            slurp = prev.callPackage ./pkgs/slurp { };
            sway-unwrapped = prev.callPackage ./pkgs/sway-unwrapped { };
            swaybg = prev.callPackage ./pkgs/swaybg { };
            swayidle = prev.callPackage ./pkgs/swayidle { };
            swaylock = prev.callPackage ./pkgs/swaylock { };
            swaylock-effects = prev.callPackage ./pkgs/swaylock-effects { };
            waybar = prev.callPackage ./pkgs/waybar {
              inherit (prev) waybar;
            };
            # waybar needs 8.1.1
            # https://github.com/NixOS/nixpkgs/pull/179584
            fmt_8 = prev.fmt_8.overrideAttrs (oldAttrs: {
              version = "8.1.1";
              src = prev.fetchFromGitHub {
                owner = "fmtlib";
                repo = "fmt";
                rev = "8.1.1";
                sha256 = "sha256-leb2800CwdZMJRWF5b1Y9ocK0jXpOX/nwo95icDf308=";
              };
            });

            waypipe = prev.callPackage ./pkgs/waypipe { };
            wayprompt = prev.callPackage ./pkgs/wayprompt { };
            wayvnc = prev.callPackage ./pkgs/wayvnc { };
            wlvncc = prev.callPackage ./pkgs/wlvncc {
              libvncserver = libvncserver_master;
            };
            wdisplays = prev.callPackage ./pkgs/wdisplays { };
            wev = prev.callPackage ./pkgs/wev { };
            wf-recorder = prev.callPackage ./pkgs/wf-recorder { };
            wlay = prev.callPackage ./pkgs/wlay { };
            obs-wlrobs = prev.callPackage ./pkgs/obs-wlrobs { };
            wl-clipboard = prev.callPackage ./pkgs/wl-clipboard { };
            wl-gammactl = prev.callPackage ./pkgs/wl-gammactl { };
            wldash = prev.callPackage ./pkgs/wldash { };
            wlogout = prev.callPackage ./pkgs/wlogout {
              inherit (prev) wlogout;
            };
            wlroots = prev.callPackage ./pkgs/wlroots {
              inherit (prev) wlroots;
            };
            wlr-randr = prev.callPackage ./pkgs/wlr-randr { };
            wlsunset = prev.callPackage ./pkgs/wlsunset { };
            wofi = prev.callPackage ./pkgs/wofi { };
            wtype = prev.callPackage ./pkgs/wtype { };
            wshowkeys = prev.callPackage ./pkgs/wshowkeys { };

            xdg-desktop-portal-wlr = prev.callPackage ./pkgs/xdg-desktop-portal-wlr { };

            # misc
            aml = prev.callPackage ./pkgs/aml { };
            clipman = prev.callPackage ./pkgs/clipman { };
            dunst = prev.callPackage ./pkgs/dunst {
              inherit (prev) dunst;
            };
            foot = prev.callPackage ./pkgs/foot {
              inherit foot;
            };
            gtk-layer-shell = prev.callPackage ./pkgs/gtk-layer-shell { };
            i3status-rust = prev.callPackage ./pkgs/i3status-rust { };
            neatvnc = prev.callPackage ./pkgs/neatvnc { };
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
          };
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
                haskellPackages.dhall-json
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
