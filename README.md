# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`.

## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-06-03 03:54](https://github.com/nixos/nixpkgs-channels/commits/ae71c13a92f7e3b7968e8b7b1db9f6238dc00a25) |
| nixpkgs/nixpkgs-unstable | [2019-05-29 03:19](https://github.com/nixos/nixpkgs-channels/commits/61f0936d1cd73760312712615233cd80195a9b47) |
| pkgs/xdg-desktop-portal-wlr | [2019-02-12 12:09](https://github.com/emersion/xdg-desktop-portal-wlr/commits/74ee43cf37e716d0119f441be96e2b3fc9838797) |
| pkgs/wlroots | [2019-06-02 13:30](https://github.com/swaywm/wlroots/commits/3dec88e4555ee5fd95ffd69133623816cb0c25c4) |
| pkgs/sway | [2019-06-04 05:47](https://github.com/swaywm/sway/commits/799f5a2cd5ffa83d73816489aa8683564bc226f7) |
| pkgs/swaybg | [2019-05-04 12:08](https://github.com/swaywm/swaybg/commits/25c6eaf15e64655385f01cbb98bffe28a862fe13) |
| pkgs/swayidle | [2019-05-23 13:10](https://github.com/swaywm/swayidle/commits/5e7bd5bd21010cb5723acdf449edb341e9880ae2) |
| pkgs/swaybg | [2019-05-04 12:08](https://github.com/swaywm/swaybg/commits/25c6eaf15e64655385f01cbb98bffe28a862fe13) |
| pkgs/swaylock | [2019-05-23 06:43](https://github.com/swaywm/swaylock/commits/a9b274eb6c63397273515151324add022a3db2a9) |
| pkgs/slurp | [2019-06-03 18:35](https://github.com/emersion/slurp/commits/0bd59daa7a3c701ec8f23bc5b4b77ea1df149a01) |
| pkgs/grim | [2019-06-03 18:50](https://github.com/emersion/grim/commits/8b7b9d984535ce16e88cfb165269cab9a13bba3b) |
| pkgs/mako | [2019-06-04 16:08](https://github.com/emersion/mako/commits/2970ef24f4c67db61874e70827bf616e7145d3e7) |
| pkgs/kanshi | [2019-06-03 04:55](https://github.com/emersion/kanshi/commits/725d7881b39591a772b8b6cbaf8bb3eab4566b17) |
| pkgs/oguri | [2019-05-26 22:46](https://github.com/vilhalmer/oguri/commits/f766b6d1f908e4b07765295892843cd8ceb7497a) |
| pkgs/waybar | [2019-06-04 15:34](https://github.com/Alexays/waybar/commits/1962caf144ebd1d8772ffa0b77630ea48e61e615) |
| pkgs/wayfire | [2019-05-22 12:55](https://github.com/WayfireWM/wayfire/commits/188dfd489ccb5e7889e998fded4070dafe922dda) |
| pkgs/wf-config | [2019-05-10 12:27](https://github.com/WayfireWM/wf-config/commits/dd6f49522c7f6f4a303d9318cddf67ff38829b0a) |
| pkgs/redshift-wayland | [2019-04-17 23:13](https://github.com/minus7/redshift/commits/eecbfedac48f827e96ad5e151de8f41f6cd3af66) |
| pkgs/waybox | [2018-11-27 14:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-04-15 15:53](https://github.com/bugaevc/wl-clipboard/commits/c010972e6b0d2eb3002c49a6a1b5620ff5f7c910) |
| pkgs/wf-recorder | [2019-05-22 13:40](https://github.com/ammen99/wf-recorder/commits/43fb1c25a80ac1e498b4e4db9c28ebd3def5804a) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/i3status-rust | [2019-06-04 15:46](https://github.com/greshake/i3status-rust/commits/d1188a91030a1b03ebf890c00f0f5e8d52c050ac) |
| pkgs/alacritty | [2019-06-03 20:01](https://github.com/jwilm/alacritty/commits/3931fb6fbce728c33b4ae2d1e604f181a7246fe0) |
| pkgs/wtype | [2019-05-30 23:01](https://github.com/atx/wtype/commits/157ae8fb7bc4235d1dd87dde479eecfc2a17665f) |
| pkgs/cage | [2019-06-03 17:55](https://github.com/Hjdskes/cage/commits/1ecba7e67cfb8655d12b0b250b92eff71886bd4f) |
<!--pkgs-->

</details>

## Usage

Continue reading for usage instructions on NixOS (only the `nixos-unstable` channel is supported!).

You can also use this [with Nix on Ubuntu. Please see the full walkthrough](docs/sway-on-ubuntu/).

### Usage (nixos-unstable)

This usage just utilizes [`overlay` functionality from `nixpkgs`]().

Note that when using the overlay, the module will automatically reference the correct
`sway` package since the newer package is overlayed ontop of `pkgs`.

```nix
{ config, lib, pkgs, ... }:
let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball url));
in
  {
    nixpkgs.overlays = [ waylandOverlay ];
    programs.sway.enable = true;
    programs.sway.extraPackages = with pkgs; [
      swaybg   # required by sway for controlling desktop wallpaper
      swayidle # used for controlling idle timeouts and triggers (screen locking, etc)
      swaylock # used for locking Wayland sessions

      waybar        # polybar-alike
      i3status-rust # simpler bar written in Rust

      grim     # screen image capture
      slurp    # screen are selection tool
      mako     # notification daemon
      oguri    # animated background utility
      glpaper  # animated background utility
      kanshi   # dynamic display configuration helper

      redshift-wayland # patched to work with wayland gamma protocol
      wl-clipboard # clipboard CLI utilities
      wf-recorder # wayland screenrecorder
      gebaar-libinput # libinput utility
      wtype     # xdotool, but for wayland
      waypipe   # network transparency for Wayland

      # TODO: more steps required to use this?
      xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
    ];
    environment.systemPackages = with pkgs; [
      # other compositors/window-managers
      wayfire  # 3D wayland compositor
      waybox   # An openbox clone on Wayland
      bspwc    # Wayland compositor based on BSPWM

      cage # A Wayland kiosk (runs a single app fullscreen)

      wayfire   # wayfire WM
      wf-config # wayfire config manager
    ];
  }
```

### Usage (wlrobs)

OBS Studio Plugins don't really fit into any NixOS infrastructure, so we'll
follow the instructions provided by.

Note, these instructions can probably be simplified to just consume a latest snapshot of this repo, rather than cloning the repo at a point in time:

```bash
mkdir -p ~/.config/nixpkgs/overlays
git clone https://github.com/colemickens/nixpkgs-wayland ~/.config/nixpkgs/overlays/nixpkgs-wayland
nix-env -iA wlrobs
mkdir -p ~/.config/obs-studio
ln -s ~/.nix-profile/share/obs/obs-plugins ~/.config/obs-studio/plugins
```

### Quick Tips: `sway`

* Usage of display managers with `sway` is not supported upstream, you should run it from a TTY.
* You will likely want a default config file to place at `$HOME/.config/sway/config`. You can use the upstream default as a starting point: https://github.com/swaywm/sway/blob/master/config.in

## Updates

* `./update.sh`:
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * calls `nix-build build.nix` to build all packages against `nixos-unstable`
  * calls `nix-build build.nixpkgs.nix` to build all packages against `nixpkgs-unstable`
  * pushes to [nixpkgs-wayland on cachix](https://nixpkgs-wayland.cachix.org)

## Binary Cache

Packages are built as described in the section above and are published to cachix.

See usage instructions at [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).

