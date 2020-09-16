
{
  description = "nixpkgs-wayland";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    cmpkgs = { url = "github:colemickens/nixpkgs/cmpkgs"; }; # TODO: remove eventually (nix-prefetch)
    cachix = { url = "github:nixos/nixpkgs/nixos-20.03"; };
  };

  outputs = inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      forAllSystems = genAttrs [ "x86_64-linux" "aarch64-linux" ];
      pkgsFor = pkgs: system: includeOverlay:
        import pkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = if includeOverlay then [ inputs.self.overlay ] else [];
        };
    in
    rec {
      overlay = final: prev:
        let
          waylandPkgs = rec {
            # wlroots-related
            cage             = prev.callPackage ./pkgs/cage {};
            drm_info         = prev.callPackage ./pkgs/drm_info {};
            emacs-pgtk       = prev.callPackage ./pkgs/emacs {};
            gebaar-libinput  = prev.callPackage ./pkgs/gebaar-libinput {};
            glpaper          = prev.callPackage ./pkgs/glpaper {};
            grim             = prev.callPackage ./pkgs/grim {};
            kanshi           = prev.callPackage ./pkgs/kanshi {};
            imv              = prev.callPackage ./pkgs/imv {};
            lavalauncher     = prev.callPackage ./pkgs/lavalauncher {};
            mako             = prev.callPackage ./pkgs/mako {};
            nwg-launchers    = prev.callPackage ./pkgs/nwg-launchers {
              nlohmann_json = prev.nlohmann_json.overrideAttrs(old: {
                version = "3.9.1";
                src = prev.fetchFromGitHub {
                  owner = "nlohmann";
                  repo = "json";
                  rev = "v3.9.1";
                  sha256 = "sha256-THordDPdH2qwk6lFTgeFmkl7iDuA/7YH71PTUe6vJCs=";
                };
              });
            };
            oguri            = prev.callPackage ./pkgs/oguri {};
            rootbar          = prev.callPackage ./pkgs/rootbar {};
            slurp            = prev.callPackage ./pkgs/slurp {};
            sway-unwrapped   = prev.callPackage ./pkgs/sway {};
            swaybg           = prev.callPackage ./pkgs/swaybg {};
            swayidle         = prev.callPackage ./pkgs/swayidle {};
            swaylock         = prev.callPackage ./pkgs/swaylock {};
            waybar           = prev.callPackage ./pkgs/waybar {};
            #waybox           = prev.callPackage ./pkgs/waybox { wlroots = wlroots-0-9-x; };
            waypipe          = prev.callPackage ./pkgs/waypipe {};
            wayvnc           = prev.callPackage ./pkgs/wayvnc {};
            wlvncc           = prev.callPackage ./pkgs/wlvncc {};
            wdisplays        = prev.callPackage ./pkgs/wdisplays {};
            wev              = prev.callPackage ./pkgs/wev {};
            wf-recorder      = prev.callPackage ./pkgs/wf-recorder {};
            wlay             = prev.callPackage ./pkgs/wlay {};
            obs-wlrobs       = prev.callPackage ./pkgs/obs-wlrobs {};
            wl-clipboard     = prev.callPackage ./pkgs/wl-clipboard {};
            wl-gammactl      = prev.callPackage ./pkgs/wl-gammactl {};
            wldash           = prev.callPackage ./pkgs/wldash {};
            wlogout          = prev.callPackage ./pkgs/wlogout {};
            wlroots          = prev.callPackage ./pkgs/wlroots {};
            wlr-randr        = prev.callPackage ./pkgs/wlr-randr {};
            wofi             = prev.callPackage ./pkgs/wofi {};
            wtype            = prev.callPackage ./pkgs/wtype {};
            xdg-desktop-portal-wlr = prev.callPackage ./pkgs/xdg-desktop-portal-wlr {};
            # temp
            #wlroots-tmp = prev.callPackage ./pkgs-temp/wlroots {};
            #wlroots-0-9-x = prev.callPackage ./pkgs-temp/wlroots-0-9-x {};
            # misc
            aml = prev.callPackage ./pkgs/aml {};
            clipman = prev.callPackage ./pkgs/clipman {};
            gtk-layer-shell = prev.callPackage ./pkgs/gtk-layer-shell {};
            i3status-rust    = prev.callPackage ./pkgs/i3status-rust {};
            neatvnc = prev.callPackage ./pkgs/neatvnc {};
            obs-studio = prev.libsForQt5.callPackage ./pkgs/obs-studio { ffmpeg = prev.ffmpeg_4; };
            wlfreerdp = prev.callPackage ./pkgs/wlfreerdp {
              inherit (prev) libpulseaudio;
              inherit (prev.gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
            };
            # wayfire stuff
            wayfire          = prev.callPackage ./pkgs/wayfire {};
            # bspwc/wltrunk stuff
            #bspwc    = prev.callPackage ./pkgs/bspwc { wlroots = wlroots-0-9-x; };
            #wltrunk  = prev.callPackage ./pkgs/wltrunk { wlroots = wlroots-0-9-x; };
          };
        in
          waylandPkgs // { inherit waylandPkgs; };

      packages = forAllSystems (system:
        (pkgsFor inputs.nixpkgs system true).waylandPkgs
      );

      defaultPackage = forAllSystems (system:
        let
          nixpkgs_ = (pkgsFor inputs.nixpkgs system true);
          attrValues = inputs.nixpkgs.lib.attrValues;
          out = packages."${system}";
        in
          nixpkgs_.symlinkJoin {
            name = "nixpkgs-wayland";
            paths = attrValues out;
          }
      );

      devShell = forAllSystems (system:
        let
          nixpkgs_ = (pkgsFor inputs.nixpkgs system false);
          cmpkgs_  = (pkgsFor inputs.cmpkgs system false);
          cachix_  = (pkgsFor inputs.cachix system false);
        in
          nixpkgs_.mkShell {
            nativeBuildInputs = []
              ++ (with cachix_; [ cachix ])
              ++ (with nixpkgs_; [ nixFlakes nix-build-uncached ])
              ++ (with nixpkgs_; [ bash cacert curl git jq mercurial openssh ripgrep ])
              ++ (with cmpkgs_; [ nix-prefetch ])
            ;
          }
      );
    };
}
