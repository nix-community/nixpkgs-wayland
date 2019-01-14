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
| nixpkgs/nixos-unstable | [2019-01-13 01:38](https://github.com/nixos/nixpkgs-channels/commits/626233eee6ea309733d2d98625750cca904799a5) |
| nixpkgs/nixpkgs-unstable | [2019-01-05 18:46](https://github.com/nixos/nixpkgs-channels/commits/7d864c6bd6391baa516118051ec5fb7e9836280e) |
| pkgs/fmt | [2019-01-13 10:08](https://github.com/fmtlib/fmt/commits/b0cde860ae3fee787c582af53858ed03684e845f) |
| pkgs/wlroots | [2019-01-13 12:45](https://github.com/swaywm/wlroots/commits/10a2c4edec5e4f0877ff4afc83178c3f08b4f063) |
| pkgs/sway-beta | [2019-01-13 17:42](https://github.com/swaywm/sway/commits/4879d40695047a4c493bd8871d810c543978a869) |
| pkgs/swayidle | [2019-01-12 17:50](https://github.com/swaywm/swayidle/commits/1fe7145c186c285ee8036e364342195d53ac296b) |
| pkgs/slurp | [2019-01-09 15:24](https://github.com/emersion/slurp/commits/d9f3d741dc3de8c24198f41befc297e43054a523) |
| pkgs/grim | [2019-01-11 14:45](https://github.com/emersion/grim/commits/b22b8a5ac3984c9b7d4ae5ba7ca112d3fd98b7a1) |
| pkgs/mako | [2019-01-06 06:30](https://github.com/emersion/mako/commits/3211130215bc91db6d284f4ccffefd81ddd0f7e2) |
| pkgs/kanshi | [2019-01-09 09:05](https://github.com/emersion/kanshi/commits/c97715789db78a88970f6a4c86ecd9e59f156956) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2018-12-27 09:16](https://github.com/vilhalmer/oguri/commits/bc82b841e0d9667b266378818b9e026308756f75) |
| pkgs/waybar | [2019-01-13 13:37](https://github.com/Alexays/waybar/commits/9348e885929db86ca5f775c5909c753197db311e) |
| pkgs/wayfire | [2019-01-13 00:57](https://github.com/WayfireWM/wayfire/commits/bf6d16d48ffeeb0cfe1c725a05823768ea759603) |
| pkgs/wf-config | [2018-12-17 00:04](https://github.com/WayfireWM/wf-config/commits/6d3426e216ac62ffa035035f9c1bea074e184018) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 15:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 06:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-01-13 03:21](https://github.com/bugaevc/wl-clipboard/commits/7a851c6690c99935d455572b121306a0decad48a) |
| pkgs/wmfocus | [2019-01-08 03:15](https://github.com/svenstaro/wmfocus/commits/7cdbd7f6dabe2932828886ffad05a90df3555e3b) |
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
      waybar # polybar-alike
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

