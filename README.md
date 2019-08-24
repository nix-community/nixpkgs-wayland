# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`. They are published to the binary cache on Cachix. Usage instructions are available on the Cachix page: [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).



## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-08-23 15:35](https://github.com/nixos/nixpkgs-channels/commits/8f84220eb292beae78b10e9e53a22d14221e3cbe) |
| nixpkgs/nixpkgs-unstable | [2019-08-23 15:05](https://github.com/nixos/nixpkgs-channels/commits/54f385241e6649128ba963c10314942d73245479) |
| pkgs/cage | [2019-07-09 12:25](https://github.com/Hjdskes/cage/commits/016ef340d20febd15ae6d4fec2b6e9fba1422cee) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/grim | [2019-07-20 16:11](https://github.com/emersion/grim/commits/a9af6088d5e6eb31c4c12a659b4641e9398e33e9) |
| pkgs/i3status-rust | [2019-08-22 06:00](https://github.com/greshake/i3status-rust/commits/72f4aa0e1fec3fdc4ac266937c3590dc1283485c) |
| pkgs/kanshi | [2019-08-13 06:00](https://github.com/emersion/kanshi/commits/d4a3c5ba156bf73d9884dd8b4f6f609b14980659) |
| pkgs/mako | [2019-07-25 05:31](https://github.com/emersion/mako/commits/7bbaf6352a1725f51c69afe9c4d276bbb293031c) |
| pkgs/oguri | [2019-08-10 16:09](https://github.com/vilhalmer/oguri/commits/2f260f8bb30a16e033394c5f9da8ebda461954de) |
| pkgs/redshift-wayland | [2019-08-24 10:39](https://github.com/minus7/redshift/commits/7621912536b3e69be3a9f6ec7c282b9bc05e3076) |
| pkgs/slurp | [2019-08-01 17:25](https://github.com/emersion/slurp/commits/cdab5c9a42b27bb7e0e7894bbd2675637a06ad7e) |
| pkgs/sway | [2019-08-24 04:41](https://github.com/swaywm/sway/commits/c3fbb01e070de6fd97ab6ce44e3e01bc84b6ac7f) |
| pkgs/swaybg | [2019-08-08 23:03](https://github.com/swaywm/swaybg/commits/a8f109af90353369e7e2e689efe8ce06eb9c60ac) |
| pkgs/swayidle | [2019-08-07 23:53](https://github.com/swaywm/swayidle/commits/91c0c4a943342ddc7fbed0777a654ac2b83185ca) |
| pkgs/swaylock | [2019-08-15 15:47](https://github.com/swaywm/swaylock/commits/ba31e2eaee6a08514a449916491f9a446e745770) |
| pkgs/waybar | [2019-08-19 08:00](https://github.com/Alexays/waybar/commits/9d0842db484a9adf734bea3254f4ed400bc7113e) |
| pkgs/waybox | [2019-06-19 22:09](https://github.com/wizbright/waybox/commits/bed7b707f24613dae334de6e7bd8f4e3313fa249) |
| pkgs/wayfire | [2019-08-21 19:56](https://github.com/WayfireWM/wayfire/commits/e5233dbe6e24c26a84762b13d7fcca2ac40dfe1b) |
| pkgs/wf-config | [2019-06-18 19:10](https://github.com/WayfireWM/wf-config/commits/f9c97d07cf9e669a346c83a3c1fce3e2d843bd51) |
| pkgs/wf-recorder | [2019-08-05 20:58](https://github.com/ammen99/wf-recorder/commits/20ab054b11d20c6d0da63917998af00c2f96d7c3) |
| pkgs/wl-clipboard | [2019-04-15 15:53](https://github.com/bugaevc/wl-clipboard/commits/c010972e6b0d2eb3002c49a6a1b5620ff5f7c910) |
| pkgs/wdisplays | [2019-08-23 22:18](https://github.com/cyclopsian/wdisplays/commits/e0f382af842f88adbf728a9c370195e566a883e8) |
| pkgs/wldash | [2019-08-11 23:48](https://github.com/kennylevinsen/wldash/commits/2f9534f75fffd58d1d0f5a580218e9f4ad589c5f) |
| pkgs/wlroots | [2019-08-24 04:39](https://github.com/swaywm/wlroots/commits/fa477c77c47ea638626d4dcd52f4a3bedbda3fd2) |
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
