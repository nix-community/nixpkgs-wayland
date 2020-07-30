# flake-wayland-apps
*nee nixpkgs-wayland*

[![builds.sr.ht status](https://builds.sr.ht/~colemickens/nixpkgs-wayland.svg)](https://builds.sr.ht/~colemickens/nixpkgs-wayland?)

- [flake-wayland-apps](#flake-wayland-apps)
  - [Overview](#overview)
  - [Usage](#usage)
      - [Flakes Usage](#flakes-usage)
      - [Example Usage](#example-usage)
  - [Packages](#packages)
  - [Tips](#tips)
      - [`sway`](#sway)
      - [`obs-studio` + `wlrobs`](#obs-studio--wlrobs)
  - [Development Guide](#development-guide)

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

There is also now flake support: `.#packages` contain a package list, `.#overlay` is the full set as an overlay.

(related: [nixpkgs-chromium](https://github.com/colemickens/nixpkgs-chromium) - Chromium with native Wayland support)

## Usage

The [NixOS Wiki page on Overlays](https://nixos.wiki/wiki/Overlays)
shows how to activate the overlay.

The [Cachix landing page for `nixpkgs-wayland`](https://nixpkgs-wayland.cachix.org) shows how to utilize the binary cache. Packages from this overlay are regularly built against `nixos-unstable` and pushed to this cache.

#### Flakes Usage

```bash
nix build "github:colemickens/nixpkgs-wayland#waybar" # builds waybar

nix build "github:colemickens/nixpkgs-wayland" # builds all packages
```

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

You could write that to a file `./wayland.nix` next to your `configuration.nix` and then use it like so:
```nix
{ config, lib, pkgs, ... }:
  {
    # ...
    imports = [
      # ...
      ./wayland.nix
    ];
  }
```

Or you can integrate those few lines into your own configuration.

## Packages

These packages were mostly recently built (and cached) against:
<!--nixpkgs-->
| Channel | Last Channel Commit Time |
| ------- | ------------------------ |
| nixos-unstable | 2020-07-30 07:22:40Z |
<!--nixpkgs-->

<!--pkgs-->
| Package | Last Updated (UTC) | Description |
| ------- | ------------------ | ----------- |
| [aml](https://github.com/any1/neatvnc) | 2020-07-26 14:57:11Z | liberally licensed VNC server library that's intended to be fast and neat |
| [bspwc](https://git.sr.ht/~bl4ckb0ne/bspwc) | 2020-01-18 03:54:38Z (pinned) | Binary space partitioning wayland compositor |
| [cage](https://www.hjdskes.nl/projects/cage/) | 2020-07-16 14:25:19Z | A Wayland kiosk |
| [clipman](https://github.com/yory8/clipman) | 2020-06-29 21:10:10Z | A basic clipboard manager for Wayland, with support for persisting copy buffers after an application exits |
| [drm_info](https://github.com/ascent12/drm_info) | 2020-07-04 07:46:47Z | Small utility to dump info about DRM devices. |
| [emacs](https://www.gnu.org/software/emacs/) | 2020-07-20 16:56:44Z | The extensible, customizable GNU text editor |
| [gebaar-libinput](https://github.com/Coffee2CodeNL/gebaar-libinput) | 2019-04-05 13:27:03Z | Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput |
| [glpaper](https://bitbucket.org/Scoopta/glpaper) | 2020-03-29 19:46:07 | GLPaper is a wallpaper program for wlroots based wayland compositors such as sway that allows you to render glsl shaders as your wallpaper |
| [grim](https://github.com/emersion/grim) | 2020-07-21 18:11:14Z | Grab images from a Wayland compositor |
| [gtk-layer-shell](https://github.com/wmww/gtk-layer-shell) | 2020-07-30 13:01:47Z | A library to create panels and other desktop components for Wayland using the Layer Shell protocol |
| [i3status-rust](https://github.com/greshake/i3status-rust) | 2020-07-15 00:13:44Z | Very resource-friendly and feature-rich replacement for i3status |
| [imv](https://github.com/eXeC64/imv) | 2020-02-08 00:29:25Z (pinned) | A command line image viewer for tiling window managers |
| [kanshi](https://github.com/emersion/kanshi) | 2020-07-20 20:54:23Z | Dynamic display configuration |
| [lavalauncher](https://git.sr.ht/~leon_plickat/lavalauncher) | 2020-07-28 04:08:16Z | A simple launcher for Wayland. |
| [mako](https://wayland.emersion.fr/mako) | 2020-07-22 16:21:59Z | A lightweight Wayland notification daemon |
| [neatvnc](https://github.com/any1/neatvnc) | 2020-07-26 13:52:00Z | liberally licensed VNC server library that's intended to be fast and neat |
| [obs-studio](https://obsproject.com) | 2020-04-12 03:22:34Z | Free and open source software for video recording and live streaming |
| [obs-wlrobs](https://sr.ht/~scoopta/wlrobs) | 2020-06-22 19:18:09 | wlrobs is an obs-studio plugin that allows you to screen capture on wlroots based wayland compositors |
| [oguri](https://github.com/vilhalmer/oguri) | 2020-05-27 14:14:43Z | A very nice animated wallpaper tool for Wayland compositors |
| [redshift-wayland](http://jonls.dk/redshift) | 2019-08-24 15:20:17Z | Screen color temperature manager |
| [rootbar](https://hg.sr.ht/~scoopta/rootbar) | 2020-04-07 01:06:53 | Root Bar is a bar for wlroots based wayland compositors such as sway and was designed to address the lack of good bars for wayland |
| [slurp](https://github.com/emersion/slurp) | 2020-04-15 13:50:29Z | Select a region in a Wayland compositor |
| [sway](https://swaywm.org) | 2020-07-27 09:27:47Z | i3-compatible tiling Wayland compositor |
| [swaybg](https://github.com/swaywm/swaybg) | 2019-08-08 23:03:44Z | Wallpaper tool for Wayland compositors |
| [swayidle](https://swaywm.org) | 2020-04-30 10:15:57Z | Sway's idle management daemon |
| [swaylock](https://swaywm.org) | 2020-07-13 13:49:10Z | Screen locker for Wayland |
| [waybar](https://github.com/Alexays/Waybar) | 2020-07-28 19:05:20Z | Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors. |
| [waybox](https://github.com/wizbright/waybox) | 2020-05-01 03:02:14Z | An openbox clone on Wayland (WIP) |
| [wayfire](https://wayfire.org/) | 2020-07-27 15:30:35Z | 3D wayland compositor |
| [waypipe](https://gitlab.freedesktop.org/mstoeckl/waypipe/) | 2020-07-06 00:16:52Z | Network transparency with Wayland |
| [wayvnc](https://github.com/any1/wayvnc) | 2020-07-28 17:32:14Z | A VNC server for wlroots based Wayland compositors |
| [wdisplays](https://github.com/cyclopsian/wdisplays) | 2020-05-09 19:42:15Z | GUI display configurator for wlroots compositors |
| [wev](https://git.sr.ht/~sircmpwn/wev) | 2020-07-07 15:20:53Z | A tool for debugging events on a Wayland window, analagous to the X11 tool xev. |
| [wf-recorder](https://github.com/ammen99/wf-recorder) | 2020-07-19 12:45:44Z | Utility program for screen recording of wlroots-based compositors |
| [wl-clipboard](https://github.com/bugaevc/wl-clipboard) | 2020-02-13 16:44:26Z | Select a region in a Wayland compositor |
| [wl-gammactl](https://github.com/mischw/wl-gammactl) | 2020-02-16 12:53:36Z | Small GTK GUI application to set contrast, brightness and gamma for wayland compositors which support the wlr-gamma-control protocol extension. |
| [wlay](https://github.com/atx/wlay) | 2019-07-04 17:03:15Z | Graphical output management for Wayland |
| [wldash](https://wldash.org) | 2020-07-22 10:42:48Z | Wayland launcher/dashboard |
| [wlfreerdp](http://www.freerdp.com/) | 2020-07-29 06:47:12Z | A Remote Desktop Protocol Client |
| [wlogout](https://github.com/ArtsyMacaw/wlogout) | 2020-03-14 05:34:47Z | A wayland based logout menu |
| [wlr-randr](https://github.com/emersion/wlr-randr) | 2020-07-27 14:33:25Z | An xrandr clone for wlroots compositors |
| [wlroots](https://github.com/swaywm/wlroots) | 2020-07-30 11:40:36Z | A modular Wayland compositor library |
| [wltrunk](https://git.sr.ht/~bl4ckb0ne/wltrunk) | 2020-03-11 13:38:35Z (pinned) | High-level Wayland compositor library based on wlroots |
| [wofi](https://hg.sr.ht/~scoopta/wofi) | 2020-07-28 16:18:53 | Wofi is a launcher/menu program for wlroots based wayland compositors such as sway |
| [wtype](https://github.com/atx/wtype) | 2020-07-15 19:59:08Z | xdotool type for wayland |
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
* `./update.sh`:
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * calls `nix-build-uncached build.nix` to build uncached packages (see: [nix-build-uncached](https://github.com/Mic92/nix-build-uncached))
  * pushes to ["nixpkgs-wayland" on cachix](https://nixpkgs-wayland.cachix.org)

Note: in some cases, you may need to manually update `cargoSha256` or `vendorSha256` in `pkgs/<pkg>/metadata.nix` as well.

If for some reason the overlay isn't progressing and you want to help, just clone the repo, run `nix-shell --command ./update.sh`
and start fixing issues in the package definitions. Sometimes you might need to edit `default.nix` to change the version
 of `wlroots` a certain package uses.
