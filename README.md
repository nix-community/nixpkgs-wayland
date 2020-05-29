# nixpkgs-wayland

[![builds.sr.ht status](https://builds.sr.ht/~colemickens/nixpkgs-wayland.svg)](https://builds.sr.ht/~colemickens/nixpkgs-wayland?)

- [nixpkgs-wayland](#nixpkgs-wayland)
  - [Overview](#overview)
  - [Usage](#usage)
      - [Example Usage](#example-usage)
  - [Packages](#packages)
  - [Tips](#tips)
      - [`sway`](#sway)
      - [`obs-studio` + `wlrobs`](#obs-studio--wlrobs)
  - [Development Guide](#development-guide)

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

(related: [nixpkgs-chromium](https://github.com/colemickens/nixpkgs-chromium) - Chromium with native Wayland support)

## Usage

The [NixOS Wiki page on Overlays](https://nixos.wiki/wiki/Overlays)
shows how to activate the overlay.

The [Cachix landing page for `nixpkgs-wayland`](https://nixpkgs-wayland.cachix.org) shows how to utilize the binary cache. Packages from this overlay are regularly built against `nixos-unstable` and pushed to this cache.

#### Example Usage

```nix
{ config, lib, pkgs, ... }:
let
  rev = "master"; # could be a git rev, to pin the overlay (not usually recommended)
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/${rev}.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball url));
in
  {
    nixpkgs.overlays = [ waylandOverlay ];
    environment.systemPackages = with pkgs; [ wayvnc ];
    # ...
  }
```

## Packages

These packages were mostly recently built (and cached) against:
<!--nixpkgs-->
| Channel | Last Channel Commit Time |
| ------- | ------------------------ |
| nixos-unstable | 2020-05-29 06:08:31Z |
<!--nixpkgs-->

<!--pkgs-->
| Package | Last Updated (UTC) | Description |
| ------- | ------------------ | ----------- |
| [aml](https://github.com/any1/neatvnc) | 2020-05-21 22:04:05Z | liberally licensed VNC server library that's intended to be fast and neat |
| [bspwc](https://git.sr.ht/~bl4ckb0ne/bspwc) | 2020-01-18 03:54:38Z (pinned) | Binary space partitioning wayland compositor |
| [cage](https://www.hjdskes.nl/projects/cage/) | 2020-04-17 19:58:26Z | A Wayland kiosk |
| [clipman](https://github.com/yory8/clipman) | 2020-05-22 07:05:18Z | A basic clipboard manager for Wayland, with support for persisting copy buffers after an application exits |
| [drm_info](https://github.com/ascent12/drm_info) | 2020-01-31 13:28:12Z | Small utility to dump info about DRM devices. |
| [gebaar-libinput](https://github.com/Coffee2CodeNL/gebaar-libinput) | 2019-04-05 13:27:03Z | Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput |
| [glpaper](https://bitbucket.org/Scoopta/glpaper) | 2020-03-29 19:46:07 | GLPaper is a wallpaper program for wlroots based wayland compositors such as sway that allows you to render glsl shaders as your wallpaper |
| [grim](https://github.com/emersion/grim) | 2020-05-21 18:54:02Z | Grab images from a Wayland compositor |
| [gtk-layer-shell](https://github.com/wmww/gtk-layer-shell) | 2020-01-03 19:52:01Z | A library to create panels and other desktop components for Wayland using the Layer Shell protocol |
| [i3status-rust](https://github.com/greshake/i3status-rust) | 2020-05-29 17:30:22Z | Very resource-friendly and feature-rich replacement for i3status |
| [imv](https://github.com/eXeC64/imv) | 2020-02-08 00:29:25Z (pinned) | A command line image viewer for tiling window managers |
| [kanshi](https://github.com/emersion/kanshi) | 2020-04-02 21:22:55Z | Dynamic display configuration |
| [lavalauncher](https://git.sr.ht/~leon_plickat/lavalauncher) | 2020-05-29 20:37:08Z | A simple launcher for Wayland. |
| [mako](https://wayland.emersion.fr/mako) | 2020-05-13 11:11:02Z | A lightweight Wayland notification daemon |
| [neatvnc](https://github.com/any1/neatvnc) | 2020-05-29 20:18:05Z | liberally licensed VNC server library that's intended to be fast and neat |
| [obs-studio](https://obsproject.com) | 2020-04-12 03:22:34Z | Free and open source software for video recording and live streaming |
| [obs-wlrobs](https://sr.ht/~scoopta/wlrobs) | 2020-05-03 00:52:41 | wlrobs is an obs-studio plugin that allows you to screen capture on wlroots based wayland compositors |
| [oguri](https://github.com/vilhalmer/oguri) | 2020-05-27 14:14:43Z | A very nice animated wallpaper tool for Wayland compositors |
| [redshift-wayland](http://jonls.dk/redshift) | 2019-08-24 15:20:17Z | Screen color temperature manager |
| [rootbar](https://hg.sr.ht/~scoopta/rootbar) | 2020-04-07 01:06:53 | Root Bar is a bar for wlroots based wayland compositors such as sway and was designed to address the lack of good bars for wayland |
| [slurp](https://github.com/emersion/slurp) | 2020-04-15 13:50:29Z | Select a region in a Wayland compositor |
| [sway](https://swaywm.org) | 2020-05-29 21:29:41Z | i3-compatible tiling Wayland compositor |
| [swaybg](https://github.com/swaywm/swaybg) | 2019-08-08 23:03:44Z | Wallpaper tool for Wayland compositors |
| [swayidle](https://swaywm.org) | 2020-04-30 10:15:57Z | Sway's idle management daemon |
| [swaylock](https://swaywm.org) | 2020-03-29 19:00:33Z | Screen locker for Wayland |
| [waybar](https://github.com/Alexays/Waybar) | 2020-05-27 07:10:38Z | Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors. |
| [waybox](https://github.com/wizbright/waybox) | 2020-05-01 03:02:14Z | An openbox clone on Wayland (WIP) |
| [wayfire](https://wayfire.org/) | 2020-05-27 22:23:21Z | 3D wayland compositor |
| [waypipe](https://gitlab.freedesktop.org/mstoeckl/waypipe/) | 2020-03-29 21:47:35Z | Network transparency with Wayland |
| [wayvnc](https://github.com/any1/wayvnc) | 2020-05-26 22:19:48Z | A VNC server for wlroots based Wayland compositors |
| [wdisplays](https://github.com/cyclopsian/wdisplays) | 2020-05-09 19:42:15Z | GUI display configurator for wlroots compositors |
| [wev](https://git.sr.ht/~sircmpwn/wev) | 2020-02-06 17:48:08Z | A tool for debugging events on a Wayland window, analagous to the X11 tool xev. |
| [wf-recorder](https://github.com/ammen99/wf-recorder) | 2020-05-27 22:22:55Z | Utility program for screen recording of wlroots-based compositors |
| [wl-clipboard](https://github.com/bugaevc/wl-clipboard) | 2020-02-13 16:44:26Z | Select a region in a Wayland compositor |
| [wl-gammactl](https://github.com/mischw/wl-gammactl) | 2020-02-16 12:53:36Z | Small GTK GUI application to set contrast, brightness and gamma for wayland compositors which support the wlr-gamma-control protocol extension. |
| [wlay](https://github.com/atx/wlay) | 2019-07-04 17:03:15Z | Graphical output management for Wayland |
| [wldash](https://wldash.org) | 2020-05-15 23:19:09Z | Wayland launcher/dashboard |
| [wlfreerdp](http://www.freerdp.com/) | 2020-05-29 08:48:23Z | A Remote Desktop Protocol Client |
| [wlogout](https://github.com/ArtsyMacaw/wlogout) | 2020-03-14 05:34:47Z | A wayland based logout menu |
| [wlr-randr](https://github.com/emersion/wlr-randr) | 2020-04-08 08:59:57Z | An xrandr clone for wlroots compositors |
| [wlroots](https://github.com/swaywm/wlroots) | 2020-05-29 06:43:32Z | A modular Wayland compositor library |
| [wltrunk](https://git.sr.ht/~bl4ckb0ne/wltrunk) | 2020-03-11 13:38:35Z (pinned) | High-level Wayland compositor library based on wlroots |
| [wofi](https://hg.sr.ht/~scoopta/wofi) | 2020-05-21 15:18:26 | Wofi is a launcher/menu program for wlroots based wayland compositors such as sway |
| [wtype](https://github.com/atx/wtype) | 2020-05-23 01:06:06Z | xdotool type for wayland |
| [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) | 2020-05-27 14:49:15Z | xdg-desktop-portal backend for wlroots |
<!--pkgs-->

</details>

## Tips

#### `sway`

* You will likely want a default config file to place at `$HOME/.config/sway/config`. You can use the upstream default as a starting point: https://github.com/swaywm/sway/blob/master/config.in
* I recommend using [`home-manager`](https://github.com/rycee/home-manager/). It has options for enabling and
  configuring Sway.
* I've recently learned that simply running `sway` at a TTY can be considered insecure. If Sway crashes, the TTY
  is left in an unlocked state. Running Sway with a DM or as `exec sway` can help mitigate this concern.

#### `obs-studio` + `wlrobs`

* I recommend using [`home-manager`](https://github.com/rycee/home-manager/). It has options for enabling and
  configuring OBS and `obs-wlrobs`. Enabling this overlay and those options is sufficient.

## Development Guide

* Use `nix-shell`.
* `./nixbuild.sh` is a wrapper I use to make sure my binary cache(s) are used,
  even if this repo is cloned on a random builder VM/machine/etc.
* `./update.sh`:
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * calls `nix-build build.nix` to build all packages against both channels
  * pushes to ["nixpkgs-wayland" on cachix](https://nixpkgs-wayland.cachix.org)

Note: in some cases, you may need to manually update `cargoSha256` or `vendorSha256` in `pkgs/<pkg>/metadata.nix` as well.
