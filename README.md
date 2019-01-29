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
| pkgs/wlroots | [2019-01-25 05:22](https://github.com/swaywm/wlroots/commits/209210d30780ec64995594b77fde3d718b655542) |
| pkgs/sway-beta | [2019-01-24 06:24](https://github.com/swaywm/sway/commits/5f45a4bbc195400dd28e086c2e0e2f479b86e4eb) |
| pkgs/swayidle | [2019-01-24 15:25](https://github.com/swaywm/swayidle/commits/f002a7a6e22704dbd2b195f43a604b22b55283ff) |
| pkgs/swaylock | [2019-01-25 06:48](https://github.com/swaywm/swaylock/commits/368f53e4f15ecac51c01e6d1a45c43d31d4bca20) |
| pkgs/slurp | [2019-01-09 15:24](https://github.com/emersion/slurp/commits/d9f3d741dc3de8c24198f41befc297e43054a523) |
| pkgs/grim | [2019-01-11 14:45](https://github.com/emersion/grim/commits/b22b8a5ac3984c9b7d4ae5ba7ca112d3fd98b7a1) |
| pkgs/mako | [2019-01-20 23:01](https://github.com/emersion/mako/commits/b30c786bdf8b90807e45ec0f52b292ee147ae1ff) |
| pkgs/kanshi | [2019-01-09 09:05](https://github.com/emersion/kanshi/commits/c97715789db78a88970f6a4c86ecd9e59f156956) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-01-19 14:57](https://github.com/vilhalmer/oguri/commits/88996939e8fb55c0a8d34596604660c87c585462) |
| pkgs/waybar | [2019-01-25 07:42](https://github.com/Alexays/waybar/commits/a0fd99b1125ae34c5cd44baf29ccd0e8292ef0ef) |
| pkgs/wayfire | [2019-01-24 12:52](https://github.com/WayfireWM/wayfire/commits/60ad07ededc2ff5005de2cb456254a4918c01768) |
| pkgs/wf-config | [2018-12-17 00:04](https://github.com/WayfireWM/wf-config/commits/6d3426e216ac62ffa035035f9c1bea074e184018) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 15:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 06:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-01-25 08:52](https://github.com/bugaevc/wl-clipboard/commits/0915628c5bf32b0a78e61e769a2979615a34f2bd) |
| pkgs/wmfocus | [2019-01-21 13:08](https://github.com/svenstaro/wmfocus/commits/69da8166d0cba19343d120e934c5088b8f8d0d43) |
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

