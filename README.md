# nixpkgs-wayland

[![builds.sr.ht status](https://builds.sr.ht/~colemickens/nixpkgs-wayland.svg)](https://builds.sr.ht/~colemickens/nixpkgs-wayland?)

- [nixpkgs-wayland](#nixpkgs-wayland)
  - [Warning](#warning)
  - [Overview](#overview)
  - [Usage](#usage)
      - [Flakes Usage](#flakes-usage)
      - [Example Usage](#example-usage)
  - [Packages](#packages)
  - [Tips](#tips)
      - [`sway`](#sway)
      - [`obs-studio` + `wlrobs`](#obs-studio--wlrobs)
  - [Development Guide](#development-guide)

## Warning
* This repo may be renamed soon. (~`nixos-wayland-apps`, maybe)
  * `wayland-nix` (ala `sops-nix`)?
  * `nixos-wayland` ?
  * keep `nixpkgs-wayland`?
* The primary cache server may change soon.

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
<!--nixpkgs-->

<!--pkgs-->
| Package | Description |
| ------- | ----------- |
| [aml](https://github.com/any1/neatvnc) | liberally licensed VNC server library that's intended to be fast and neat |
| [bspwc](https://git.sr.ht/~bl4ckb0ne/bspwc) | Binary space partitioning wayland compositor |
| [cage](https://www.hjdskes.nl/projects/cage/) | A Wayland kiosk |
| [clipman](https://github.com/yory8/clipman) | A basic clipboard manager for Wayland, with support for persisting copy buffers after an application exits |
| [drm_info](https://github.com/ascent12/drm_info) | Small utility to dump info about DRM devices. |
| [emacs](https://www.gnu.org/software/emacs/) | The extensible, customizable GNU text editor |
| [gebaar-libinput](https://github.com/Coffee2CodeNL/gebaar-libinput) | Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput |
| [glpaper](https://bitbucket.org/Scoopta/glpaper) | GLPaper is a wallpaper program for wlroots based wayland compositors such as sway that allows you to render glsl shaders as your wallpaper |
| [grim](https://github.com/emersion/grim) | Grab images from a Wayland compositor |
| [gtk-layer-shell](https://github.com/wmww/gtk-layer-shell) | A library to create panels and other desktop components for Wayland using the Layer Shell protocol |
| [i3status-rust](https://github.com/greshake/i3status-rust) | Very resource-friendly and feature-rich replacement for i3status |
| [imv](https://github.com/eXeC64/imv) | A command line image viewer for tiling window managers |
| [kanshi](https://github.com/emersion/kanshi) | Dynamic display configuration |
| [lavalauncher](https://git.sr.ht/~leon_plickat/lavalauncher) | A simple launcher for Wayland. |
| [mako](https://wayland.emersion.fr/mako) | A lightweight Wayland notification daemon |
| [neatvnc](https://github.com/any1/neatvnc) | liberally licensed VNC server library that's intended to be fast and neat |
| [obs-studio](https://obsproject.com) | Free and open source software for video recording and live streaming |
| [obs-wlrobs](https://sr.ht/~scoopta/wlrobs) | wlrobs is an obs-studio plugin that allows you to screen capture on wlroots based wayland compositors |
| [oguri](https://github.com/vilhalmer/oguri) | A very nice animated wallpaper tool for Wayland compositors |
| [rootbar](https://hg.sr.ht/~scoopta/rootbar) | Root Bar is a bar for wlroots based wayland compositors such as sway and was designed to address the lack of good bars for wayland |
| [slurp](https://github.com/emersion/slurp) | Select a region in a Wayland compositor |
| [sway](https://swaywm.org) | i3-compatible tiling Wayland compositor |
| [swaybg](https://github.com/swaywm/swaybg) | Wallpaper tool for Wayland compositors |
| [swayidle](https://swaywm.org) | Sway's idle management daemon |
| [swaylock](https://swaywm.org) | Screen locker for Wayland |
| [waybar](https://github.com/Alexays/Waybar) | Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors. |
| [waybox](https://github.com/wizbright/waybox) | An openbox clone on Wayland (WIP) |
| [wayfire](https://wayfire.org/) | 3D wayland compositor |
| [waypipe](https://gitlab.freedesktop.org/mstoeckl/waypipe/) | Network transparency with Wayland |
| [wayvnc](https://github.com/any1/wayvnc) | A VNC server for wlroots based Wayland compositors |
| [wdisplays](https://github.com/cyclopsian/wdisplays) | GUI display configurator for wlroots compositors |
| [wev](https://git.sr.ht/~sircmpwn/wev) | A tool for debugging events on a Wayland window, analagous to the X11 tool xev. |
| [wf-recorder](https://github.com/ammen99/wf-recorder) | Utility program for screen recording of wlroots-based compositors |
| [wlay](https://github.com/atx/wlay) | Graphical output management for Wayland |
| [wl-clipboard](https://github.com/bugaevc/wl-clipboard) | Select a region in a Wayland compositor |
| [wldash](https://wldash.org) | Wayland launcher/dashboard |
| [wlfreerdp](http://www.freerdp.com/) | A Remote Desktop Protocol Client |
| [wl-gammactl](https://github.com/mischw/wl-gammactl) | Small GTK GUI application to set contrast, brightness and gamma for wayland compositors which support the wlr-gamma-control protocol extension. |
| [wlogout](https://github.com/ArtsyMacaw/wlogout) | A wayland based logout menu |
| [wlroots](https://github.com/swaywm/wlroots) | A modular Wayland compositor library |
| [wlr-randr](https://github.com/emersion/wlr-randr) | An xrandr clone for wlroots compositors |
| [wltrunk](https://git.sr.ht/~bl4ckb0ne/wltrunk) | High-level Wayland compositor library based on wlroots |
| [wofi](https://hg.sr.ht/~scoopta/wofi) | Wofi is a launcher/menu program for wlroots based wayland compositors such as sway |
| [wtype](https://github.com/atx/wtype) | xdotool type for wayland |
| [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) | xdg-desktop-portal backend for wlroots |
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
