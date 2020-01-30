# nixpkgs-wayland

(related: [nixpkgs-chromium](https://github.com/colemickens/nixpkgs-chromium)
and [nixpkgs-graphics](https://github.com/colemickens/nixpkgs-graphics))

- [nixpkgs-wayland](#nixpkgs-wayland)
  - [Overview](#overview)
  - [Packages](#packages)
  - [Usage](#usage)
    - [Usage (nixos-unstable)](#usage-nixos-unstable)
    - [Usage (wlrobs)](#usage-wlrobs)
    - [Quick Tips: `sway`](#quick-tips-sway)
  - [Development Guide](#development-guide)
      - [Building](#building)
      - [Updating all packages](#updating-all-packages)

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Note that hese packages can also be used on Ubuntu, to some extent. See [the Ubuntu demo](docs/sway-on-ubuntu) for more information.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`. They are published to the binary cache on Cachix. Usage instructions are available on the Cachix page: [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).

These packages were mostly recently built against:
<!--nixpkgs-->
| Channel | Last Channel Commit Time |
| ------- | ------------------------ |
| nixos-unstable | 2020-01-27 10:15:28 +0100 |
| nixpkgs-unstable | 2020-01-29 16:57:25 -0500 |
<!--nixpkgs-->

## Packages

<!--pkgs-->
| Package | Last Update | Description |
| ------- | ----------- | ----------- |
| [bspwc](https://git.sr.ht/~bl4ckb0ne/bspwc) | 2019-10-14 14:41:16 -0400 (pinned) | Binary space partitioning wayland compositor |
| [cage](https://www.hjdskes.nl/projects/cage/) | 2020-01-26 18:18:49 +0100 | A Wayland kiosk |
| [drm_info](https://github.com/ascent12/drm_info) | 2020-01-13 13:57:53 +1000 | Small utility to dump info about DRM devices. |
| [gebaar-libinput](https://github.com/Coffee2CodeNL/gebaar-libinput) | 2019-04-05 15:27:03 +0200 | Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput |
| [glpaper](https://bitbucket.org/Scoopta/glpaper) | 2019-03-08 16:52 -0800 | GLPaper is a wallpaper program for wlroots based wayland compositors such as sway that allows you to render glsl shaders as your wallpaper |
| [grim](https://github.com/emersion/grim) | 2020-01-16 12:33:31 +0100 | Grab images from a Wayland compositor |
| [gtk-layer-shell](https://github.com/wmww/gtk-layer-shell) | 2020-01-03 14:52:01 -0500 | A library to create panels and other desktop components for Wayland using the Layer Shell protocol |
| [i3status-rust](https://github.com/greshake/i3status-rust) | 2020-01-24 16:27:37 -0500 | Very resource-friendly and feature-rich replacement for i3status |
| [imv](https://github.com/eXeC64/imv) | 2019-12-21 22:54:26 +0000 | A command line image viewer for tiling window managers |
| [kanshi](https://github.com/emersion/kanshi) | 2020-01-13 22:41:20 +0100 | Dynamic display configuration |
| [lavalauncher](https://git.sr.ht/~leon_plickat/lavalauncher) | 2020-01-16 04:01:11 +0100 | A simple launcher for Wayland. |
| [mako](https://wayland.emersion.fr/mako) | 2020-01-27 10:59:20 +0100 | A lightweight Wayland notification daemon |
| [neatvnc](https://github.com/any1/neatvnc) | 2020-01-29 19:59:14 +0000 | liberally licensed VNC server library that's intended to be fast and neat |
| [oguri](https://github.com/vilhalmer/oguri) | 2019-12-09 16:26:38 -0500 | A very nice animated wallpaper tool for Wayland compositors |
| [redshift-wayland](http://jonls.dk/redshift) | 2019-08-24 17:20:17 +0200 | Screen color temperature manager |
| [rootbar](https://hg.sr.ht/~scoopta/rootbar) | 2019-03-18 10:47 -0700 | Root Bar is a bar for wlroots based wayland compositors such as sway and was designed to address the lack of good bars for wayland |
| [slurp](https://github.com/emersion/slurp) | 2019-08-01 20:25:04 +0300 | Select a region in a Wayland compositor |
| [sway](https://swaywm.org) | 2020-01-27 11:31:41 -0700 | i3-compatible tiling Wayland compositor |
| [swaybg](https://github.com/swaywm/swaybg) | 2019-08-09 08:03:44 +0900 | Wallpaper tool for Wayland compositors |
| [swayidle](https://swaywm.org) | 2020-01-23 07:30:21 -0700 | Sway's idle management daemon |
| [swaylock](https://swaywm.org) | 2020-01-23 07:30:27 -0700 | Screen locker for Wayland |
| [waybar](https://github.com/Alexays/Waybar) | 2020-01-23 14:03:40 +0000 | Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors. |
| [waybox](https://github.com/wizbright/waybox) | 2019-06-19 17:09:41 -0500 | An openbox clone on Wayland (WIP) |
| [wayfire](https://wayfire.org/) | 2020-01-29 10:26:08 +0100 | 3D wayland compositor |
| [waypipe](https://gitlab.freedesktop.org/mstoeckl/waypipe/) | 2019-11-28 12:03:29 -0500 | Network transparency with Wayland |
| [wayvnc](https://github.com/any1/wayvnc) | 2020-01-29 21:20:14 +0000 |  |
| [wdisplays](https://github.com/cyclopsian/wdisplays) | 2020-01-12 06:23:14 +0000 | GUI display configurator for wlroots compositors |
| [wev](https://git.sr.ht/~sircmpwn/wev) | 2019-12-12 12:10:08 -0500 | A tool for debugging events on a Wayland window, analagous to the X11 tool xev. |
| [wf-config](https://github.com/WayfireWM/wf-config) | 2020-01-04 10:00:43 +0200 | A library for managing configuration files, written for wayfire |
| [wf-recorder](https://github.com/ammen99/wf-recorder) | 2020-01-16 13:22:25 +0100 | Utility program for screen recording of wlroots-based compositors |
| [wl-clipboard](https://github.com/bugaevc/wl-clipboard) | 2019-10-03 15:16:09 +0300 | Select a region in a Wayland compositor |
| [wlay](https://github.com/atx/wlay) | 2019-07-04 19:03:15 +0200 | Graphical output management for Wayland |
| [wldash](https://wldash.org) | 2020-01-08 11:49:19 +0100 | Wayland launcher/dashboard |
| [wlogout](https://github.com/ArtsyMacaw/wlogout) | 2020-01-22 15:52:48 -0600 | A wayland based logout menu |
| [wlr-randr](https://github.com/emersion/wlr-randr) | 2019-03-22 16:38:05 +0200 | An xrandr clone for wlroots compositors |
| [wlrobs](https://sr.ht/~scoopta/wlrobs) | 2019-03-16 15:06 -0700 | wlrobs is an obs-studio plugin that allows you to screen capture on wlroots based wayland compositors |
| [wlroots](https://github.com/swaywm/wlroots) | 2020-01-28 15:45:58 +0100 | A modular Wayland compositor library |
| [wltrunk](https://git.sr.ht/~bl4ckb0ne/wltrunk) | 2019-11-10 16:09:56 -0500 (pinned) | High-level Wayland compositor library based on wlroots |
| [wofi](https://hg.sr.ht/~scoopta/wofi) | 2019-08-17 18:34 -0700 | Wofi is a launcher/menu program for wlroots based wayland compositors such as sway |
| [wtype](https://github.com/atx/wtype) | 2019-07-01 17:33:04 +0200 | xdotool type for wayland |
| [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) | 2019-12-09 12:55:12 +0100 | xdg-desktop-portal backend for wlroots |
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

NOTE: OBS-Studio is pretty rough around the edges in Wayland, regardless of if XWayland is used. `wf-recorder` might be easier to use.

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

* `./update.sh`:
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * calls `nix-build build.nix -A all` to build all packages against both channels
  * pushes to [nixpkgs-wayland on cachix](https://nixpkgs-wayland.cachix.org)

Note: in some cases, you may need to manually update `cargoSha256` as well.
