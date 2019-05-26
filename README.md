# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`.

## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-05-26 09:24](https://github.com/nixos/nixpkgs-channels/commits/c7bcd4277cc9a656207b636dbc62fef21dc64c78) |
| nixpkgs/nixpkgs-unstable | [2019-05-20 20:55](https://github.com/nixos/nixpkgs-channels/commits/650a295621b27c4ebe0fa64a63fd25323e64deb3) |
| pkgs/xdg-desktop-portal-wlr | [2019-02-12 12:09](https://github.com/emersion/xdg-desktop-portal-wlr/commits/74ee43cf37e716d0119f441be96e2b3fc9838797) |
| pkgs/wlroots | [2019-05-22 23:42](https://github.com/swaywm/wlroots/commits/0ab1bb623e58bafef315c9eb33a430e72d40408a) |
| pkgs/sway | [2019-05-25 16:35](https://github.com/swaywm/sway/commits/e92ac7d5523d24132de59055b8c982b46ceae70a) |
| pkgs/swaybg | [2019-05-04 12:08](https://github.com/swaywm/swaybg/commits/25c6eaf15e64655385f01cbb98bffe28a862fe13) |
| pkgs/swayidle | [2019-05-23 13:10](https://github.com/swaywm/swayidle/commits/5e7bd5bd21010cb5723acdf449edb341e9880ae2) |
| pkgs/swaybg | [2019-05-04 12:08](https://github.com/swaywm/swaybg/commits/25c6eaf15e64655385f01cbb98bffe28a862fe13) |
| pkgs/swaylock | [2019-05-23 06:43](https://github.com/swaywm/swaylock/commits/a9b274eb6c63397273515151324add022a3db2a9) |
| pkgs/slurp | [2019-03-16 19:52](https://github.com/emersion/slurp/commits/92dc1ea1cf79541d157e98af3fb6aa4df501fef4) |
| pkgs/grim | [2019-02-20 13:18](https://github.com/emersion/grim/commits/6994df611f55a4089209fdd5ad8d9301e4fb0167) |
| pkgs/mako | [2019-05-24 15:52](https://github.com/emersion/mako/commits/ca8e763f06756136c534b1bbd2e5b536be6b1995) |
| pkgs/kanshi | [2019-02-02 23:21](https://github.com/emersion/kanshi/commits/970267e400c21a6bb51a1c80a0aadfd1e6660a7b) |
| pkgs/oguri | [2019-05-26 22:46](https://github.com/vilhalmer/oguri/commits/f766b6d1f908e4b07765295892843cd8ceb7497a) |
| pkgs/waybar | [2019-05-26 22:08](https://github.com/Alexays/waybar/commits/6e69af89678a441c1145edc7210b545b1ea03ede) |
| pkgs/wayfire | [2019-05-22 12:55](https://github.com/WayfireWM/wayfire/commits/188dfd489ccb5e7889e998fded4070dafe922dda) |
| pkgs/wf-config | [2019-05-10 12:27](https://github.com/WayfireWM/wf-config/commits/dd6f49522c7f6f4a303d9318cddf67ff38829b0a) |
| pkgs/redshift-wayland | [2019-04-17 23:13](https://github.com/minus7/redshift/commits/eecbfedac48f827e96ad5e151de8f41f6cd3af66) |
| pkgs/waybox | [2018-11-27 14:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-04-15 15:53](https://github.com/bugaevc/wl-clipboard/commits/c010972e6b0d2eb3002c49a6a1b5620ff5f7c910) |
| pkgs/wf-recorder | [2019-05-22 13:40](https://github.com/ammen99/wf-recorder/commits/43fb1c25a80ac1e498b4e4db9c28ebd3def5804a) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/i3status-rust | [2019-05-17 23:12](https://github.com/greshake/i3status-rust/commits/6d52d66b53facd734fea38c61fc7090110dcd46d) |
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

      # TODO: more steps required to use this?
      xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
    ];
    environment.systemPackages = with pkgs; [
      # other compositors/window-managers
      wayfire  # 3D wayland compositor
      waybox   # An openbox clone on Wayland
      bspwc    # Wayland compositor based on BSPWM

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

