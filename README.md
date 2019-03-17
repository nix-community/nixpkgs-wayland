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
| nixpkgs/nixos-unstable | [2019-03-16 12:48](https://github.com/nixos/nixpkgs-channels/commits/da1a2b1eeafa66b4419b4f275396d8a731eccb61) |
| nixpkgs/nixpkgs-unstable | [2019-03-17 03:10](https://github.com/nixos/nixpkgs-channels/commits/0125544e2a0552590c87dca1583768b49ba911c0) |
| pkgs/wlroots | [2019-03-15 16:38](https://github.com/swaywm/wlroots/commits/6b7f5e4010103bffaf4666b77f7a4369295588d8) |
| pkgs/xdg-desktop-portal-wlr | [2019-02-12 12:09](https://github.com/emersion/xdg-desktop-portal-wlr/commits/74ee43cf37e716d0119f441be96e2b3fc9838797) |
| pkgs/sway | [2019-03-17 16:05](https://github.com/swaywm/sway/commits/0327c999d7f69de6356b3b30c19b131d029f6e95) |
| pkgs/swayidle | [2019-02-16 16:43](https://github.com/swaywm/swayidle/commits/3e392e31c0684854a9a145cda1bd9a44c99ef24d) |
| pkgs/swaylock | [2019-02-12 22:27](https://github.com/swaywm/swaylock/commits/6b3be42264b9eaa8524ea4f0d93fbd1d82495d90) |
| pkgs/slurp | [2019-03-16 19:52](https://github.com/emersion/slurp/commits/92dc1ea1cf79541d157e98af3fb6aa4df501fef4) |
| pkgs/grim | [2019-02-20 13:18](https://github.com/emersion/grim/commits/6994df611f55a4089209fdd5ad8d9301e4fb0167) |
| pkgs/mako | [2019-03-08 08:53](https://github.com/emersion/mako/commits/9cf8a0335c811ccf4a6ea72be4c30aa646804365) |
| pkgs/kanshi | [2019-02-02 23:21](https://github.com/emersion/kanshi/commits/970267e400c21a6bb51a1c80a0aadfd1e6660a7b) |
| pkgs/wlstream | [2018-07-15 21:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-02-19 14:19](https://github.com/vilhalmer/oguri/commits/59a51758f4b14f60113aad6ae4ebb92d80060ce5) |
| pkgs/waybar | [2019-03-15 08:43](https://github.com/Alexays/waybar/commits/3257968a2844ac5d1d00769c0af45398aeebdb58) |
| pkgs/wayfire | [2019-03-17 07:49](https://github.com/WayfireWM/wayfire/commits/09b28398068c4f65d7ef1313c0633e24cf302ce2) |
| pkgs/wf-config | [2019-02-13 15:49](https://github.com/WayfireWM/wf-config/commits/52a7963f8a77bfa98b657c76304d7ad515b69878) |
| pkgs/redshift-wayland | [2018-11-07 20:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 23:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 14:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-02-12 15:59](https://github.com/bugaevc/wl-clipboard/commits/a60fba0fad8399071bd36dbd2fb8fe0ef4cf6f11) |
| pkgs/i3status-rust | [2019-03-14 02:18](https://github.com/greshake/i3status-rust/commits/a4485ad9e75b46e2dcadb9eca1042a5b655d24fc) |
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
    programs.sway-beta.enable = true;
    programs.sway-beta.extraPackages = with pkgs; [
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

