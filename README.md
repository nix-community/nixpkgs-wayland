# nixpkgs-wayland

[![builds.sr.ht status](https://builds.sr.ht/~colemickens/nixpkgs-wayland.svg)](https://builds.sr.ht/~colemickens/nixpkgs-wayland?)

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
| nixos-unstable | 2020-05-17 00:44:14 +0100 |
<!--nixpkgs-->

## Packages

<!--pkgs-->
| Package | Last Update | Description |
| ------- | ----------- | ----------- |
| [i3status-rust](https://github.com/greshake/i3status-rust) | 2020-05-18 01:16:24 +0900 | Very resource-friendly and feature-rich replacement for i3status |
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

Note: in some cases, you may need to manually update `cargoSha256` or `vendorSha256` in `pkgs/<pkg>/metadata.nix` as well.
