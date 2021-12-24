{
  description = "nixpkgs-wayland";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    cachix = { url = "github:nixos/nixpkgs/nixos-21.05"; };
  };

  outputs = inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = genAttrs supportedSystems;
      pkgsFor = pkgs: system: overlays:
        import pkgs {
          inherit system overlays;
          config.allowUnfree = true;
          config.allowAliases = false;
        };
      pkgs_ = genAttrs (builtins.attrNames inputs) (inp: genAttrs supportedSystems (sys: pkgsFor inputs."${inp}" sys []));
      opkgs_ = overlays: genAttrs (builtins.attrNames inputs) (inp: genAttrs supportedSystems (sys: pkgsFor inputs."${inp}" sys overlays));
    in
    rec {
      devShell = forAllSystems (system:
        pkgs_.nixpkgs.${system}.mkShell {
          nativeBuildInputs = []
            ++ (with pkgs_.cachix.${system}; [ cachix ])
            ++ (with pkgs_.nixpkgs.${system}; [
                nixUnstable nix-prefetch nix-build-uncached
                bash cacert curl git jq mercurial openssh ripgrep parallel
                haskellPackages.dhall-json
            ]); });

      packages = forAllSystems (system:
        (opkgs_ [overlay]).nixpkgs.${system}.waylandPkgs);

      overlay = final: prev:
        let
          _wayland-protocols-master = prev.callPackage ./pkgs/wayland-protocols-master {
            wayland-protocols = prev.wayland-protocols;
          };

          _mesonNewer = prev.callPackage ./pkgs-temp/meson {};
          _wlroots = prev.callPackage ./pkgs/wlroots {
            meson = _mesonNewer;
            wayland-protocols = _wayland-protocols-master;
            wayland = _waylandNewer;
          };
          _waylandNewer = prev.wayland.overrideAttrs(old: {
            version = "1.20.0";
            src = prev.fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "wayland";
              repo = "wayland";
              rev = "1.20.0";
              sha256 = "sha256-N+riSb3F3vcyUlNdlSnOUrKdDtBcGn9rUyCAi3nel6E=";
            };
            patches = [
              (prev.writeText "patch.diff" ''
                  From 378623b0e39b12bb04d3a3a1e08e64b31bd7d99d Mon Sep 17 00:00:00 2001
                  From: Florian Klink <flokli@flokli.de>
                  Date: Fri, 27 Nov 2020 10:22:20 +0100
                  Subject: [PATCH] add placeholder for @nm@

                  ---
                  egl/meson.build | 2 +-
                  1 file changed, 1 insertion(+), 1 deletion(-)

                  diff --git a/egl/meson.build b/egl/meson.build
                  index dee9b1d..e477546 100644
                  --- a/egl/meson.build
                  +++ b/egl/meson.build
                  @@ -11,7 +11,7 @@ wayland_egl = library(
                  
                   executable('wayland-egl-abi-check', 'wayland-egl-abi-check.c')
                  
                  -nm_path = find_program('nm').path()
                  +nm_path = find_program('${prev.stdenv.cc.targetPrefix}nm').path()
                  
                   test(
                   	'wayland-egl symbols check',
                  -- 
                  2.29.2
                '')
            ];
          });
          waylandPkgs = rec {
            # wlroots-related
            cage             = prev.callPackage ./pkgs/cage {
              wlroots = prev.wlroots;
              meson = _mesonNewer;
            };
            drm_info         = prev.callPackage ./pkgs/drm_info {};
            foot             = prev.callPackage ./pkgs/foot { inherit foot; };
            gebaar-libinput  = prev.callPackage ./pkgs/gebaar-libinput {};
            glpaper          = prev.callPackage ./pkgs/glpaper {};
            grim             = prev.callPackage ./pkgs/grim {};
            kanshi           = prev.callPackage ./pkgs/kanshi {};
            imv              = prev.callPackage ./pkgs/imv {
              imv = prev.imv;
            };
            lavalauncher     = prev.callPackage ./pkgs/lavalauncher {};
            mako             = prev.callPackage ./pkgs/mako {
              meson = _mesonNewer;
            };
            oguri            = prev.callPackage ./pkgs/oguri {};
            rootbar          = prev.callPackage ./pkgs/rootbar {};
            sirula           = prev.callPackage ./pkgs/sirula {};
            slurp            = prev.callPackage ./pkgs/slurp {};
            sway-unwrapped   = prev.callPackage ./pkgs/sway-unwrapped {
              meson = _mesonNewer;
              sway-unwrapped = prev.sway-unwrapped;
              wayland = _waylandNewer;
              wayland-protocols =_wayland-protocols-master;
            };
            swaybg           = prev.callPackage ./pkgs/swaybg {};
            swayidle         = prev.callPackage ./pkgs/swayidle {};
            swaylock         = prev.callPackage ./pkgs/swaylock {};
            waybar           = prev.callPackage ./pkgs/waybar {
              waybar = prev.waybar;
            };
            waypipe          = prev.callPackage ./pkgs/waypipe {};
            wayvnc           = prev.callPackage ./pkgs/wayvnc {};
            wlvncc           = prev.callPackage ./pkgs/wlvncc {
              libvncserver = libvncserver_master;
            };
            wdisplays        = prev.callPackage ./pkgs/wdisplays {};
            wev              = prev.callPackage ./pkgs/wev {};
            wf-recorder      = prev.callPackage ./pkgs/wf-recorder {};
            wlay             = prev.callPackage ./pkgs/wlay {};
            obs-wlrobs       = prev.callPackage ./pkgs/obs-wlrobs {};
            wl-clipboard     = prev.callPackage ./pkgs/wl-clipboard {};
            wl-gammactl      = prev.callPackage ./pkgs/wl-gammactl {};
            wldash           = prev.callPackage ./pkgs/wldash {};
            wlogout          = prev.callPackage ./pkgs/wlogout {
              wlogout = prev.wlogout;
            };
            wlroots          = _wlroots;
            wlr-randr        = prev.callPackage ./pkgs/wlr-randr {};
            wlsunset         = prev.callPackage ./pkgs/wlsunset {};
            wofi             = prev.callPackage ./pkgs/wofi {};
            wtype            = prev.callPackage ./pkgs/wtype {};
            xdg-desktop-portal-wlr = prev.callPackage ./pkgs/xdg-desktop-portal-wlr {};

            wshowkeys        = prev.callPackage ./pkgs/wshowkeys {};

            wayland-protocols-master = _wayland-protocols-master;

            # misc
            aml = prev.callPackage ./pkgs/aml {};
            clipman = prev.callPackage ./pkgs/clipman {};
            dunst = prev.callPackage ./pkgs/dunst {
              dunst = prev.dunst;
            };
            gtk-layer-shell = prev.callPackage ./pkgs/gtk-layer-shell {};
            i3status-rust    = prev.callPackage ./pkgs/i3status-rust {
              i3status-rust = prev.i3status-rust;
            };
            neatvnc = prev.callPackage ./pkgs/neatvnc {};

            nwg-launchers = prev.callPackage ./pkgs/nwg-launchers {};
            nwg-panel = prev.callPackage ./pkgs/nwg-panel {
              nwg-panel = prev.nwg-panel;
            };

            obs-studio = prev.libsForQt5.callPackage ./pkgs/obs-studio {
              ffmpeg = prev.ffmpeg_4;
              vlc = prev.vlc;
            };
            wlfreerdp = prev.callPackage ./pkgs/wlfreerdp {
              inherit (prev) libpulseaudio;
              inherit (prev.gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
            };
            # wayfire stuff
            wayfire          = prev.callPackage ./pkgs/wayfire {
              meson = _mesonNewer;
              wayland-protocols = _wayland-protocols-master;
            };

            libvncserver_master = prev.callPackage ./pkgs/libvncserver_master {
              libvncserver = prev.libvncserver;
            };
          };
        in
          waylandPkgs // { inherit waylandPkgs; };
    };
}
