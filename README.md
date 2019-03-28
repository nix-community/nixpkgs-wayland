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
| nixpkgs/nixos-unstable | [2019-03-22 09:15](https://github.com/nixos/nixpkgs-channels/commits/07b42ccf2de451342982b550657636d891c4ba35) |
| nixpkgs/nixpkgs-unstable | [2019-03-23 10:23](https://github.com/nixos/nixpkgs-channels/commits/796a8764ab85746f916e2cc8f6a9a5fc6d4d03ac) |
| pkgs/wlroots | [2019-03-27 17:31](https://github.com/swaywm/wlroots/commits/08454adadaa5db9f136531eddbe290a933a335bf) |
| pkgs/xdg-desktop-portal-wlr | [2019-02-12 12:09](https://github.com/emersion/xdg-desktop-portal-wlr/commits/74ee43cf37e716d0119f441be96e2b3fc9838797) |
| pkgs/sway | [2019-03-27 16:07](https://github.com/swaywm/sway/commits/bfdee1319ffc8a720d0536a752a19ba23615a1e2) |
| pkgs/swayidle | [2019-02-16 16:43](https://github.com/swaywm/swayidle/commits/3e392e31c0684854a9a145cda1bd9a44c99ef24d) |
| pkgs/swaylock | [2019-03-20 21:07](https://github.com/swaywm/swaylock/commits/7d5a73b0a99ca9b4c73a34faceda8bef2576fe23) |
| pkgs/slurp | [2019-03-16 19:52](https://github.com/emersion/slurp/commits/92dc1ea1cf79541d157e98af3fb6aa4df501fef4) |
| pkgs/grim | [2019-02-20 13:18](https://github.com/emersion/grim/commits/6994df611f55a4089209fdd5ad8d9301e4fb0167) |
| pkgs/mako | [2019-03-25 18:10](https://github.com/emersion/mako/commits/87170d5a3499225906a594f47557ea30e34662dd) |
| pkgs/kanshi | [2019-02-02 23:21](https://github.com/emersion/kanshi/commits/970267e400c21a6bb51a1c80a0aadfd1e6660a7b) |
| pkgs/wlstream | [2018-07-15 21:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-02-19 14:19](https://github.com/vilhalmer/oguri/commits/59a51758f4b14f60113aad6ae4ebb92d80060ce5) |
| pkgs/waybar | [2019-03-27 07:15](https://github.com/Alexays/waybar/commits/b17984f75e80f708afe7b45c444f3732adfc2aab) |
| pkgs/wayfire | [2019-03-26 14:22](https://github.com/WayfireWM/wayfire/commits/784c3210500f5b7fad76ac710bf4bb3070e09833) |
| pkgs/wf-config | [2019-03-24 21:20](https://github.com/WayfireWM/wf-config/commits/a0504d822160c5fc69d3af9cf853e2cc2e5ce3e4) |
| pkgs/redshift-wayland | [2018-11-07 20:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 23:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 14:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-02-12 15:59](https://github.com/bugaevc/wl-clipboard/commits/a60fba0fad8399071bd36dbd2fb8fe0ef4cf6f11) |
| pkgs/wf-recorder | [2019-03-26 14:56](https://github.com/ammen99/wf-recorder/commits/e6073f5d9c85b5db53b6fc319569daf4e1f1f62c) |
| pkgs/gebaar-libinput | [2019-03-27 09:41](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/6e7341cc4e53929618eda0c9b21a77943e2b9ce8) |
| pkgs/i3status-rust | [2019-03-21 12:58](https://github.com/greshake/i3status-rust/commits/18300e6b9259053b80c37aef56c958fe5f50062b) |
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

