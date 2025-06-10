{
  description = "nixpkgs-wayland";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    lib-aggregate = {
      url = "github:nix-community/lib-aggregate";
    };
    flake-compat = {
      url = "github:nix-community/flake-compat";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://nixpkgs-wayland.cachix.org" ];
    extra-trusted-substituters = [ "https://nixpkgs-wayland.cachix.org" ];
    extra-trusted-public-keys = [
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  outputs =
    inputs:
    let
      inherit (inputs.lib-aggregate) lib;
      inherit (inputs) self;

      waylandOverlay =
        final: prev:
        let
          template =
            {
              attrName,
              nixpkgsAttrName ? "",
              extra ? { },
              replace ? { },
              replaceInput ? { },
            }:
            import ./templates/template.nix {
              inherit
                prev
                attrName
                extra
                replace
                nixpkgsAttrName
                replaceInput
                ;
            };
          checkMutuallyExclusive = lib.mutuallyExclusive (map (e: e.attrName) attrsExtraChangesNeeded) (
            map (e: e.attrName) attrsNoExtraChangesNeeded
          );
          genPackagesGH =
            if checkMutuallyExclusive then
              lib.listToAttrs (
                map (a: {
                  name = a.attrName;
                  value = template a;
                }) (attrsExtraChangesNeeded ++ attrsNoExtraChangesNeeded)
              )
            else
              throw "some 'attrName' value is in both attrsExtraChangesNeeded and attrsNoExtraChangesNeeded";

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
              replace = previousAttrs: {
                patches = [];
                postUnpack =
                  let
                    # Derived from subprojects/cava.wrap
                    libcava = rec {
                      version = "0.10.4";
                      src = prev.fetchFromGitHub {
                        owner = "LukashonakV";
                        repo = "cava";
                        rev = version;
                        hash = "sha256-9eTDqM+O1tA/3bEfd1apm8LbEcR9CVgELTIspSVPMKM=";
                      };
                    };
                    # Derived from subprojects/catch2.wrap
                    catch2 = rec {
                      version = "3.7.0";
                      src = prev.fetchFromGitHub {
                        owner = "catchorg";
                        repo = "Catch2";
                        rev = "v${version}";
                        hash = "sha256-U9hv6DaqN5eCMcAQdfFPqWpsbqDFxRQixELSGbNlc0g=";
                      };
                    };
                  in
                  ''
                    (
                      cd "$sourceRoot"
                      cp -R --no-preserve=mode,ownership ${libcava.src} subprojects/cava-${libcava.version}
                      cp -R --no-preserve=mode,ownership ${catch2.src} subprojects/Catch2-${catch2.version}
                      patchShebangs .
                    )
                  '';
              };
            }
            {
              attrName = "gtk-layer-shell";
              extra.nativeBuildInputs = [ prev.vala ];
              replace.patches = [ ];
            }
            {
              attrName = "sway-unwrapped";
              extra.buildInputs = [ prev.xorg.xcbutilwm ];
              replaceInput = {
                wlroots = final.wlroots;
                wayland-protocols = final.new-wayland-protocols;
              };
              replace = previousAttrs: {
                mesonFlags = lib.remove "-Dxwayland=disabled" (
                  lib.remove "-Dxwayland=enabled" prev.sway-unwrapped.mesonFlags
                );
                patches =
                  let
                    patchesToRemove = [
                      (prev.fetchpatch {
                        name = "libinput-1.27-p1.patch";
                        url = "https://github.com/swaywm/sway/commit/bbadf9b8b10d171a6d5196da7716ea50ee7a6062.patch";
                        hash = "sha256-lA+oL1vqGQOm7K+AthzHYBzmOALrDgxzX/5Dx7naq84=";
                      })
                      (prev.fetchpatch {
                        name = "libinput-1.27-p2.patch";
                        url = "https://github.com/swaywm/sway/commit/e2409aa49611bee1e1b99033461bfab0a7550c48.patch";
                        hash = "sha256-l598qfq+rpKy3/0arQruwd+BsELx85XDjwIDkb/o6og=";
                      })
                    ];
                  in
                  (lib.filter (
                    patch: !(lib.any (rmpatch: rmpatch != patch) patchesToRemove)
                  ) previousAttrs.patches);

              };
            }
            {
              attrName = "cage";
              extra.buildInputs = [ prev.xorg.xcbutilwm ];
              replaceInput = {
                wlroots_0_18 = prev.wlroots_0_19;
              };
              # _FORTIFY_SOURCE requires compiling with optimization (-O)
              # PR https://github.com/NixOS/nixpkgs/pull/232917 added -O0
              replace.CFLAGS = "";
              # https://github.com/cage-kiosk/cage/commit/d3fb99d6654325ec46277cfdb589f89316bed701
              replace.mesonFlags = lib.remove "-Dxwayland=true" (
                lib.remove "-Dxwayland=false" prev.cage.mesonFlags
              );
            }
            {
              attrName = "wob";
              extra.buildInputs = [
                prev.pixman
                prev.cmocka
              ];
            }
            {
              attrName = "libvncserver_master";
              nixpkgsAttrName = "libvncserver";
              # The version in nixpkgs has different paths so the patch is updated here.
              replace.patches = [ ./pkgs/libvncserver_master/pkgconfig.patch ];
            }
            {
              attrName = "wayvnc";
              nixpkgsAttrName = "wayvnc";
              extra.buildInputs = [ prev.jansson ];
            }
            {
              attrName = "eww";
              nixpkgsAttrName = "eww";
              extra.buildInputs = [
                prev.libdbusmenu
                prev.libdbusmenu-gtk3
              ];
              # patch was applied upstream
              replace.cargoPatches = [ ];
              # cargoPatches is addded to patches
              replace.patches = [ ];
            }
            {
              attrName = "wf-recorder";
              replace.patches = [];
              extra.buildInputs = [
                prev.mesa
                prev.pipewire
              ];
            }
            {
              attrName = "xdg-desktop-portal-wlr";
              nixpkgsAttrName = "xdg-desktop-portal-wlr";
              replace.patches = [ ];
            }
            {
              attrName = "new-wayland-protocols";
              nixpkgsAttrName = "wayland-protocols";
            }
            # {
            #   attrName = "wl-screenrec";
            #   # soon in nixpkgs
            #   extra.buildInputs = [ prev.libdrm ];
            #   replace.doCheck = false;
            # }
            {
              attrName = "wbg";
              extra.buildInputs = [
                prev.libjxl
                prev.pixman
              ];
            }
            {
              attrName = "dunst";
              # remove once nixpkgs is above 1.11.1
              replace = previousAttrs: {
                postInstall =
                  builtins.replaceStrings
                    [
                      ''
                        substituteInPlace $out/share/zsh/site-functions/_dunstctl $out/share/fish/vendor_completions.d/{dunstctl,dunstify} \
                          --replace-fail "jq" "${lib.getExe prev.jq}"
                      ''
                    ]
                    [
                      ''
                        substituteInPlace $out/share/zsh/site-functions/_dunstctl $out/share/fish/vendor_completions.d/{dunstctl,dunstify}.fish \
                          --replace-fail "jq" "${lib.getExe prev.jq}"
                      ''
                    ]
                    previousAttrs.postInstall;
              };
            }
            {
              attrName = "neatvnc";
              replace.patches = [];
              replaceInput = {
                ffmpeg = prev.ffmpeg_7;
              };
            }
            {
              attrName = "waypipe";
              extra = {
                depsBuildBuild = [ prev.pkg-config ];
                nativeBuildInputs = [ prev.pkg-config prev.wayland-scanner ];
                buildInputs = [ prev.wayland ];
              };
            }
          ];

          # these do not need changes from the package that nixpkgs has
          attrsNoExtraChangesNeeded = lib.attrValues (
            lib.genAttrs
              [
                "gebaar-libinput"
                "glpaper"
                "imv"
                "mako"
                "slurp"
                "swaybg"
                "swayidle"
                "swaylock-effects"
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
                "sirula"
                "swww"
                "wlay"
                "i3status-rust"
                "shotman"
              ]
              (s: {
                attrName = s;
              })
          );

          waylandPkgs = genPackagesGH // rec {
            # wlroots-related
            salut = prev.callPackage ./pkgs/salut { };
            wlvncc = prev.callPackage ./pkgs/wlvncc { libvncserver = final.libvncserver_master; };
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
              wlroots = prev.wlroots_0_18;
              wayland-protocols = final.new-wayland-protocols;
            };

            wl-gammarelay-rs = prev.callPackage ./pkgs/wl-gammarelay-rs { };

            freerdp3 = prev.callPackage ./pkgs/freerdp3 {
              inherit (prev.darwin.apple_sdk.frameworks)
                AudioToolbox
                AVFoundation
                Carbon
                Cocoa
                CoreMedia
                ;
              inherit (prev.gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
            };

            # misc
            foot = prev.callPackage ./pkgs/foot { inherit foot; };
          };
        in
        waylandPkgs // { inherit waylandPkgs; };
    in
    lib.flake-utils.eachSystem
      [
        "aarch64-linux"
        "x86_64-linux"
        "riscv64-linux"
      ]
      (
        system:
        let
          pkgsFor =
            pkgs: overlays:
            import pkgs {
              inherit system overlays;
              config.allowUnfree = true;
              config.allowAliases = false;
            };
          pkgs_ = lib.genAttrs (builtins.attrNames inputs) (inp: pkgsFor inputs."${inp}" [ ]);
          opkgs_ = overlays: lib.genAttrs (builtins.attrNames inputs) (inp: pkgsFor inputs."${inp}" overlays);
          waypkgs = (opkgs_ [ self.overlays.default ]).nixpkgs;
        in
        rec {
          devShells.default = pkgs_.nixpkgs.mkShell {
            nativeBuildInputs = with pkgs_.nixpkgs; [
              nix
              nushell
              cachix
              cacert
              git
              mercurial
              ripgrep
              sd
            ];
          };

          formatter = pkgs_.nixpkgs.nixfmt-rfc-style;

          bundle = pkgs_.nixpkgs.symlinkJoin {
            name = "nixpkgs-wayland-bundle";
            paths = builtins.attrValues (
              lib.filterAttrs (_: v: lib.meta.availableOn pkgs_.nixpkgs.stdenv.hostPlatform v) waypkgs.waylandPkgs
            );
          };

          packages = waypkgs.waylandPkgs // {
            default = bundle;
          };
        }
      )
    // {
      # overlays have to be outside of eachSystem block
      overlay = waylandOverlay;

      overlays.default = waylandOverlay;
    };
}
