# nixpkgs-wayland

- [nixpkgs-wayland](#nixpkgs-wayland)
  - [Overview](#overview)
  - [Usage](#usage)
  - [Status](#status)
  - [Packages](#packages)
  - [Tips](#tips)
      - [`sway`](#sway)
      - [`obs-studio` + `wlrobs`](#obs-studio--wlrobs)
  - [Development Guide](#development-guide)

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

There is [a limited, best-effort changelog available](./CHANGELOG.md).

(related: [nixpkgs-chromium](https://github.com/colemickens/nixpkgs-chromium) - Chromium with native Wayland support)

## Usage

The [NixOS Wiki page on Overlays](https://nixos.wiki/wiki/Overlays)
shows how to activate the overlay.

The [Cachix landing page for `nixpkgs-wayland`](https://nixpkgs-wayland.cachix.org) shows how to utilize the binary cache. Packages from this overlay are regularly built against `nixos-unstable` and pushed to this cache.

## Status

These packages were mostly recently built against:
<!--nixpkgs-->
| Channel | Last Channel Commit Time |
| ------- | ------------------------ |
| nixos-unstable | 2020-02-26 03:53:16 -0500 |
<!--nixpkgs-->

## Packages

<!--pkgs-->
| Package | Last Update | Description |
| ------- | ----------- | ----------- |
| [bspwc](https://git.sr.ht/~bl4ckb0ne/bspwc) | 2019-10-14 14:41:16 -0400 (pinned) | Binary space partitioning wayland compositor |
| [cage](https://www.hjdskes.nl/projects/cage/) | 2020-02-23 16:00:57 +0100 | A Wayland kiosk |
| [clipman](https://github.com/yory8/clipman) | 2020-02-25 22:24:56 +0100 | A basic clipboard manager for Wayland, with support for persisting copy buffers after an application exits |
| [drm_info](https://github.com/ascent12/drm_info) | 2020-01-31 14:28:12 +0100 | Small utility to dump info about DRM devices. |
| [gebaar-libinput](https://github.com/Coffee2CodeNL/gebaar-libinput) | 2019-04-05 15:27:03 +0200 | Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput |
| [glpaper](https://bitbucket.org/Scoopta/glpaper) | 2019-03-08 16:52 -0800 | GLPaper is a wallpaper program for wlroots based wayland compositors such as sway that allows you to render glsl shaders as your wallpaper |
| [grim](https://github.com/emersion/grim) | 2020-02-10 01:05:43 +0100 | Grab images from a Wayland compositor |
| [gtk-layer-shell](https://github.com/wmww/gtk-layer-shell) | 2020-01-03 14:52:01 -0500 | A library to create panels and other desktop components for Wayland using the Layer Shell protocol |
| [i3status-rust](https://github.com/greshake/i3status-rust) | 2020-02-24 14:32:19 -0500 | Very resource-friendly and feature-rich replacement for i3status |
| [imv](https://github.com/eXeC64/imv) | 2019-12-21 22:54:26 +0000 (pinned) | A command line image viewer for tiling window managers |
| [kanshi](https://github.com/emersion/kanshi) | 2020-02-22 21:24:07 +0100 | Dynamic display configuration |
| [lavalauncher](https://git.sr.ht/~leon_plickat/lavalauncher) | 2020-02-22 19:06:57 +0100 | A simple launcher for Wayland. |
| [mako](https://wayland.emersion.fr/mako) | 2020-02-15 00:56:32 +0100 | A lightweight Wayland notification daemon |
| [neatvnc](https://github.com/any1/neatvnc) | 2020-02-21 23:04:19 +0000 | liberally licensed VNC server library that's intended to be fast and neat |
| [obs-studio](https://obsproject.com) | 2020-02-06 15:34:32 -0500 | Free and open source software for video recording and live streaming |
| [obs-wlrobs](https://sr.ht/~scoopta/wlrobs) | 2019-03-16 15:06 -0700 | wlrobs is an obs-studio plugin that allows you to screen capture on wlroots based wayland compositors |
| [oguri](https://github.com/vilhalmer/oguri) | 2020-02-23 17:54:07 -0500 | A very nice animated wallpaper tool for Wayland compositors |
| [redshift-wayland](http://jonls.dk/redshift) | 2019-08-24 17:20:17 +0200 | Screen color temperature manager |
| [rootbar](https://hg.sr.ht/~scoopta/rootbar) | 2019-03-18 10:47 -0700 | Root Bar is a bar for wlroots based wayland compositors such as sway and was designed to address the lack of good bars for wayland |
| [slurp](https://github.com/emersion/slurp) | 2020-02-11 11:59:41 +0100 | Select a region in a Wayland compositor |
| [sway](https://swaywm.org) | 2020-02-26 16:26:13 +0100 | i3-compatible tiling Wayland compositor |
| [swaybg](https://github.com/swaywm/swaybg) | 2019-08-09 08:03:44 +0900 | Wallpaper tool for Wayland compositors |
| [swayidle](https://swaywm.org) | 2020-02-10 20:38:23 +0100 | Sway's idle management daemon |
| [swaylock](https://swaywm.org) | 2020-01-23 07:30:27 -0700 | Screen locker for Wayland |
| [waybar](https://github.com/Alexays/Waybar) | 2020-02-24 10:53:26 +0000 | Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors. |
| [waybox](https://github.com/wizbright/waybox) | 2020-02-26 09:31:27 -0600 | An openbox clone on Wayland (WIP) |
| [wayfire](https://wayfire.org/) | 2020-02-22 21:44:18 +0100 | 3D wayland compositor |
| [waypipe](https://gitlab.freedesktop.org/mstoeckl/waypipe/) | 2020-02-10 11:10:09 -0500 | Network transparency with Wayland |
| [wayvnc](https://github.com/any1/wayvnc) | 2020-02-21 23:28:36 +0000 |  |
| [wdisplays](https://github.com/cyclopsian/wdisplays) | 2020-01-12 06:23:14 +0000 | GUI display configurator for wlroots compositors |
| [wev](https://git.sr.ht/~sircmpwn/wev) | 2020-02-06 12:48:08 -0500 | A tool for debugging events on a Wayland window, analagous to the X11 tool xev. |
| [wf-config](https://github.com/WayfireWM/wf-config) | 2020-02-23 17:43:47 +0100 | A library for managing configuration files, written for wayfire |
| [wf-recorder](https://github.com/ammen99/wf-recorder) | 2020-01-16 13:22:25 +0100 | Utility program for screen recording of wlroots-based compositors |
| [wl-clipboard](https://github.com/bugaevc/wl-clipboard) | 2020-02-13 17:44:26 +0100 | Select a region in a Wayland compositor |
| [wl-gammactl](https://github.com/mischw/wl-gammactl) | 2020-02-16 14:53:36 +0200 | Small GTK GUI application to set contrast, brightness and gamma for wayland compositors which support the wlr-gamma-control protocol extension. |
| [wlay](https://github.com/atx/wlay) | 2019-07-04 19:03:15 +0200 | Graphical output management for Wayland |
| [wldash](https://wldash.org) | 2020-01-08 11:49:19 +0100 | Wayland launcher/dashboard |
| [wlogout](https://github.com/ArtsyMacaw/wlogout) | 2020-02-12 19:40:30 -0600 | A wayland based logout menu |
| [wlr-randr](https://github.com/emersion/wlr-randr) | 2019-03-22 16:38:05 +0200 | An xrandr clone for wlroots compositors |
| [wlroots](https://github.com/swaywm/wlroots) | 2020-02-26 13:43:53 +0100 | A modular Wayland compositor library |
| [wltrunk](https://git.sr.ht/~bl4ckb0ne/wltrunk) | 2019-11-10 16:09:56 -0500 (pinned) | High-level Wayland compositor library based on wlroots |
| [wofi](https://hg.sr.ht/~scoopta/wofi) | 2019-08-17 18:34 -0700 | Wofi is a launcher/menu program for wlroots based wayland compositors such as sway |
| [wtype](https://github.com/atx/wtype) | 2019-07-01 17:33:04 +0200 | xdotool type for wayland |
| [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) | 2019-12-09 12:55:12 +0100 | xdg-desktop-portal backend for wlroots |
<!--pkgs-->

</details>

## Tips

#### `sway`

* You will likely want a default config file to place at `$HOME/.config/sway/config`. You can use the upstream default as a starting point: https://github.com/swaywm/sway/blob/master/config.in

#### `obs-studio` + `wlrobs`

* `obs-wlrobs` is packaged in nixpkgs and integrated with its `obs-studio`
infrastructure.
* This overlay provides a (likely newer) version of `obs-wlrobs`.
* This overlay also provides a patched version of `obs-studio` that works
  natively on Wayland.
* To utilize OBS-Studio with Wayland, simply install `obs-studio` and `obs-wlrobs`
via your preferred method, along with activating this overlay.
* *(Also, `wf-recorder` can screen record and stream to various RTMP services.
Depending on your use-case, it's a lighter alternative to OBS-Studio.)*


## Development Guide

* Use `nix-shell`.
* `./nixbuild.sh` is a wrapper I use to make sure my binary cache(s) are used,
  even if this repo is cloned on a random builder VM/machine/etc.
* `./update.sh`:
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * calls `nix-build build.nix -A all` to build all packages against both channels
  * pushes to [nixpkgs-wayland on cachix](https://nixpkgs-wayland.cachix.org)

Note: in some cases, you may need to manually update `cargoSha256` or `modSha256` in `pkgs/<pkg>/metadata.nix` as well.
