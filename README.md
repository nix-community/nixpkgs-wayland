# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`. They are published to the binary cache on Cachix. Usage instructions are available on the Cachix page: [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).



## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-09-09 01:18](https://github.com/nixos/nixpkgs-channels/commits/e19054ab3cd5b7cc9a01d0efc71c8fe310541065) |
| nixpkgs/nixpkgs-unstable | [2019-09-15 21:40](https://github.com/nixos/nixpkgs-channels/commits/c4196cca9acd1c51f62baf10fcbe34373e330bb3) |
| pkgs/cage | [2019-08-27 16:14](https://github.com/Hjdskes/cage/commits/0fb513fb85eb5846eb598b91a0fc79dc16b5da36) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/grim | [2019-07-20 16:11](https://github.com/emersion/grim/commits/a9af6088d5e6eb31c4c12a659b4641e9398e33e9) |
| pkgs/i3status-rust | [2019-09-09 14:01](https://github.com/greshake/i3status-rust/commits/f90bc9874d060a24276c2808275f4068d30ba47b) |
| pkgs/kanshi | [2019-09-06 17:20](https://github.com/emersion/kanshi/commits/823cdb0f6f6bfc4a119af76ef2be8a8d2b01dff3) |
| pkgs/mako | [2019-09-09 22:16](https://github.com/emersion/mako/commits/0b3b66e6e4c04ff44a164c366931d1e6beaca9e4) |
| pkgs/oguri | [2019-09-03 02:54](https://github.com/vilhalmer/oguri/commits/5372ee49bb22b0370100be8589f3692da58602e3) |
| pkgs/redshift-wayland | [2019-08-24 15:20](https://github.com/minus7/redshift/commits/7da875d34854a6a34612d5ce4bd8718c32bec804) |
| pkgs/slurp | [2019-08-01 17:25](https://github.com/emersion/slurp/commits/cdab5c9a42b27bb7e0e7894bbd2675637a06ad7e) |
| pkgs/sway | [2019-09-19 16:47](https://github.com/swaywm/sway/commits/fba248ed5ee3888b961e3272f7e29b9d9ecdb335) |
| pkgs/swaybg | [2019-08-08 23:03](https://github.com/swaywm/swaybg/commits/a8f109af90353369e7e2e689efe8ce06eb9c60ac) |
| pkgs/swayidle | [2019-08-27 15:18](https://github.com/swaywm/swayidle/commits/844dfde8538c1f55aaf254c18649d419bdff7a92) |
| pkgs/swaylock | [2019-09-12 20:33](https://github.com/swaywm/swaylock/commits/426e1ce93d1344414bd3fa0eb7cd50d7ca9ec075) |
| pkgs/waybar | [2019-09-19 21:07](https://github.com/Alexays/waybar/commits/bae83ee4e31a4daeb9ecfd069153003c8612e026) |
| pkgs/waybox | [2019-06-19 22:09](https://github.com/wizbright/waybox/commits/bed7b707f24613dae334de6e7bd8f4e3313fa249) |
| pkgs/wayfire | [2019-09-18 21:30](https://github.com/WayfireWM/wayfire/commits/5b91b876ce0a7ff3e62bf72870d741c02002db90) |
| pkgs/wf-config | [2019-09-04 07:39](https://github.com/WayfireWM/wf-config/commits/e8d57d19183e0d358671e3aa7335cc2d3722321d) |
| pkgs/wf-recorder | [2019-09-17 19:16](https://github.com/ammen99/wf-recorder/commits/d6ea419b3caad8ec89c66eef504dc043fec26d2a) |
| pkgs/wl-clipboard | [2019-09-17 20:48](https://github.com/bugaevc/wl-clipboard/commits/a60a0a468cddeb2de8cb83264e1874ab3f46fbd5) |
| pkgs/wdisplays | [2019-09-09 15:10](https://github.com/cyclopsian/wdisplays/commits/03de59d30733a4228208ab4ce7613ced0e02c9b9) |
| pkgs/wldash | [2019-09-18 09:19](https://github.com/kennylevinsen/wldash/commits/1ae11bab29ca82f415d7d0ad5abf6727b431c11c) |
| pkgs/wlroots | [2019-09-19 16:44](https://github.com/swaywm/wlroots/commits/020a33e057bd2c5b6250149b0e955d6874ecb1b7) |
| pkgs/wtype | [2019-07-01 15:33](https://github.com/atx/wtype/commits/9752f420ffb1dd8b9cbc692d9f90cbe2cca343d9) |
| pkgs/xdg-desktop-portal-wlr | [2019-07-24 16:38](https://github.com/emersion/xdg-desktop-portal-wlr/commits/13076d0c10613e9ae73e61dd82b24ae9a6529667) |
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
      xwayland
      swaybg   # required by sway for controlling desktop wallpaper
      swayidle # used for controlling idle timeouts and triggers (screen locking, etc)
      swaylock # used for locking Wayland sessions

      waybar        # polybar-alike
      i3status-rust # simpler bar written in Rust

      gebaar-libinput  # libinput gestures utility
      glpaper          # GL shaders as wallpaper
      grim             # screen image capture
      kanshi           # dynamic display configuration helper
      mako             # notification daemon
      oguri            # animated background utility
      redshift-wayland # patched to work with wayland gamma protocol
      slurp            # screen area selection tool
      waypipe          # network transparency for Wayland
      wf-recorder      # wayland screenrecorder
      wl-clipboard     # clipboard CLI utilities
      wtype            # xdotool, but for wayland

      # TODO: more steps required to use this?
      xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
    ];
    environment.systemPackages = with pkgs; [
      # other compositors/window-managers
      waybox   # An openbox clone on Wayland
      bspwc    # Wayland compositor based on BSPWM
      cage     # A Wayland kiosk (runs a single app fullscreen)

      wayfire   # 3D wayland compositor
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

## Development Guide

#### Building

1. Install `nix`.
2. Run `nix-build build.nix -A nixosUnstable` to build the packages against current `nixos-unstable`.
3. Run `nix-build build.nix -A nixpkgsUnstable` to build them against `nixpkgs-unstable`.

Do note that those channels are actually pinned in this repo. The update script will also update those
refs. Making sure the channels are up-to-date means that you will be building the packages that are going
to be requested by users on those channels (who are up-to-date on the channel).

#### Updating all packages

(Note, this currently only supports the repos hosted on GitHub. I need to switch to something else that
more intelligently caches the checkouts and pulls and checks for updates, rather than hitting an API that
won't work for SourceHut/Gitlab. However, the script should tell you at the end which repos (might) need 
manual updates.)

* `./update.sh`:
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * calls `nix-build build.nix -A nixosUnstable` to build all packages against `nixos-unstable`
  * calls `nix-build build.nix -A nixpkgsUnstable` to build all packages against `nixpkgs-unstable`
  * pushes to [nixpkgs-wayland on cachix](https://nixpkgs-wayland.cachix.org)
