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
| nixpkgs/nixos-unstable | [2019-04-25 07:41](https://github.com/nixos/nixpkgs-channels/commits/dfd8f84aef129f1978e446b5d45ef05cd4421821) |
| nixpkgs/nixpkgs-unstable | [2019-04-25 06:56](https://github.com/nixos/nixpkgs-channels/commits/ed1b59a98e7bd61dd7eac266569c294fb6b16300) |
| pkgs/wlroots | [2019-04-28 21:00](https://github.com/swaywm/wlroots/commits/22dd7d3731634fc8e719768c8154a6e65f9e8f84) |
| pkgs/xdg-desktop-portal-wlr | [2019-02-12 12:09](https://github.com/emersion/xdg-desktop-portal-wlr/commits/74ee43cf37e716d0119f441be96e2b3fc9838797) |
| pkgs/sway | [2019-04-28 18:07](https://github.com/swaywm/sway/commits/3b3e0560beb9a44f038736fd4c344052fdfe3f81) |
| pkgs/swayidle | [2019-02-16 16:43](https://github.com/swaywm/swayidle/commits/3e392e31c0684854a9a145cda1bd9a44c99ef24d) |
| pkgs/swaylock | [2019-04-22 22:14](https://github.com/swaywm/swaylock/commits/f403cc07021d75f54752584ead2f53f5dc50b673) |
| pkgs/slurp | [2019-03-16 19:52](https://github.com/emersion/slurp/commits/92dc1ea1cf79541d157e98af3fb6aa4df501fef4) |
| pkgs/grim | [2019-02-20 13:18](https://github.com/emersion/grim/commits/6994df611f55a4089209fdd5ad8d9301e4fb0167) |
| pkgs/mako | [2019-04-28 08:29](https://github.com/emersion/mako/commits/9a3b0f338907df4ac4e0e81e947343270fc0df31) |
| pkgs/kanshi | [2019-02-02 23:21](https://github.com/emersion/kanshi/commits/970267e400c21a6bb51a1c80a0aadfd1e6660a7b) |
| pkgs/wlstream | [2018-07-15 21:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-02-19 14:19](https://github.com/vilhalmer/oguri/commits/59a51758f4b14f60113aad6ae4ebb92d80060ce5) |
| pkgs/waybar | [2019-04-26 19:57](https://github.com/Alexays/waybar/commits/e8f31a0c4f659f9ab36eae048b4ef927c6013db3) |
| pkgs/wayfire | [2019-04-21 07:40](https://github.com/WayfireWM/wayfire/commits/910d745cf2dd043a5a3436e98a5a00ba76642420) |
| pkgs/wf-config | [2019-03-24 21:20](https://github.com/WayfireWM/wf-config/commits/a0504d822160c5fc69d3af9cf853e2cc2e5ce3e4) |
| pkgs/redshift-wayland | [2019-04-17 23:13](https://github.com/minus7/redshift/commits/eecbfedac48f827e96ad5e151de8f41f6cd3af66) |
| pkgs/bspwc | [2018-12-29 23:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 14:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-04-15 15:53](https://github.com/bugaevc/wl-clipboard/commits/c010972e6b0d2eb3002c49a6a1b5620ff5f7c910) |
| pkgs/wf-recorder | [2019-04-21 13:25](https://github.com/ammen99/wf-recorder/commits/ddb96690556371007e316577ed1b14f0cb62e13c) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/i3status-rust | [2019-04-27 18:59](https://github.com/greshake/i3status-rust/commits/d04d08cbd4d13c64b1e3b7a8d21c46acee3bc281) |
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
      swayidle # used for controlling idle timeouts and triggers (screen locking, etc)
      swaylock # used for locking Wayland sessions

      waybar        # polybar-alike
      i3status-rust # simpler bar written in Rust

      grim     # screen image capture
      slurp    # screen are selection tool
      mako     # notification daemon
      wlstream # screen recorder
      oguri    # animated background utility
      kanshi   # dynamic display configuration helper
      redshift-wayland # patched to work with wayland gamma protocol

      xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
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

