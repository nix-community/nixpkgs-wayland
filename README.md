# flake-wayland-apps
*nee nixpkgs-wayland*

[![builds.sr.ht status](https://builds.sr.ht/~colemickens/nixpkgs-wayland.svg)](https://builds.sr.ht/~colemickens/nixpkgs-wayland?)

- [flake-wayland-apps](#flake-wayland-apps)
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
| Package | Last Updated (UTC) | Description |
| ------- | ------------------ | ----------- |
| [aml](https://github.com/any1/neatvnc) | 2020-07-26 14:57:11Z | liberally licensed VNC server library that's intended to be fast and neat |
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
