# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`.

(Sister repositories: [nixpkgs-kubernetes](https://github.com/colemickens/nixpkgs-kubernetes), [nixpkgs-colemickens](https://github.com/colemickens/nixpkgs-colemickens))

## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-01-20 09:32](https://github.com/nixos/nixpkgs-channels/commits/bc41317e24317b0f506287f2d5bab00140b9b50e) |
| nixpkgs/nixpkgs-unstable | [2019-01-24 07:01](https://github.com/nixos/nixpkgs-channels/commits/11cf7d6e1ffd5fbc09a51b76d668ad0858a772ed) |
| pkgs/wlroots | [2019-01-29 12:12](https://github.com/swaywm/wlroots/commits/77c25c152629e8bd3e8287d862728c72d03ac1dd) |
| pkgs/sway-beta | [2019-01-29 10:38](https://github.com/swaywm/sway/commits/4f4424f66caa527869acf79a5e64d31a6212378f) |
| pkgs/swayidle | [2019-01-27 05:22](https://github.com/swaywm/swayidle/commits/d18c7cbb5deb0f0d6a9758d0fc820bcdf9bf9cda) |
| pkgs/swaylock | [2019-01-29 11:48](https://github.com/swaywm/swaylock/commits/effdea523158c8e30f7654a87402df155a2229ad) |
| pkgs/slurp | [2019-01-09 15:24](https://github.com/emersion/slurp/commits/d9f3d741dc3de8c24198f41befc297e43054a523) |
| pkgs/grim | [2019-01-29 06:09](https://github.com/emersion/grim/commits/1e8dde32b6e5fd6b03230aea290840f64be515db) |
| pkgs/mako | [2019-01-20 23:01](https://github.com/emersion/mako/commits/b30c786bdf8b90807e45ec0f52b292ee147ae1ff) |
| pkgs/kanshi | [2019-01-09 09:05](https://github.com/emersion/kanshi/commits/c97715789db78a88970f6a4c86ecd9e59f156956) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-01-19 14:57](https://github.com/vilhalmer/oguri/commits/88996939e8fb55c0a8d34596604660c87c585462) |
| pkgs/waybar | [2019-01-28 10:38](https://github.com/Alexays/waybar/commits/4d3c2191cb86a43199fe6e686e642d74e9bcf52b) |
| pkgs/wayfire | [2019-01-28 22:41](https://github.com/WayfireWM/wayfire/commits/0fd706cce528b6a0470e1885a0fee394a16bf6db) |
| pkgs/wf-config | [2018-12-17 00:04](https://github.com/WayfireWM/wf-config/commits/6d3426e216ac62ffa035035f9c1bea074e184018) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 15:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 06:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-01-29 06:42](https://github.com/bugaevc/wl-clipboard/commits/60654b06da413fb244704fd3352a5447ed3921e3) |
| pkgs/wmfocus | [2019-01-28 19:22](https://github.com/svenstaro/wmfocus/commits/6ef7956933bff1e61f2d10d679ae91e962bc09d1) |
| pkgs/i3status-rust | [2018-12-24 09:01](https://github.com/greshake/i3status-rust/commits/31a595ee2b7ca84c3205560d96ec7bcf8ce02d0b) |
<!--pkgs-->

</details>

## Usage

Continue reading for usage instructions on NixOS (only the `nixos-unstable` channel is supported!).

You can also use this [with Nix on Ubuntu. Please see the full walkthrough](docs/sway-on-ubuntu/).

### Usage (nixos-unstable)

This usage just utilizes [`overlay` functionality from `nixpkgs`]().

Note that when using the overlay, the module will automatically reference the correct
`sway-beta` package since the newer package is overlayed ontop of `pkgs`.

```nix
{ config, lib, pkgs, ... }:
let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball url));
in
  {
    nixpkgs.overlays = [ waylandOverlay ];
    programs.sway-beta.enable = true;
    programs.sway-beta.extraPackages = with pkgs; [
      swayidle # used for idle/screensaver/lock management

      waybar        # polybar-alike
      i3status-rust # simpler bar written in Rust

      grim     # screen image capture
      slurp    # screen are selection tool
      mako     # notification daemon
      wlstream # screen recorder
      oguri    # animated background utility
      wmfocus  # fast window picker utility
      kanshi   # dynamic display configuration helper
      redshift-wayland # patched to work with wayland gamma protocol
    ];
    environment.systemPackages = with pkgs; [
      # other compositors/window-managers
      wayfire  # 3D wayland compositor
      waybox   # An openbox clone on Wayland
      bspwc    # Wayland compositor based on BSPWM
    ];
  }
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

