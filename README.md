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
| nixpkgs/nixos-unstable | [2018-12-29 17:29](https://github.com/nixos/nixpkgs-channels/commits/201d739b0ffbebceb444864d1856babcd1a666a8) |
| nixpkgs/nixpkgs-unstable | [2019-01-02 20:26](https://github.com/nixos/nixpkgs-channels/commits/b0f40b7851309ed20524f0b05bd4b1dda13d4ea4) |
| pkgs/fmt | [2019-01-02 16:05](https://github.com/fmtlib/fmt/commits/39623a7400026a7ec492aa813f11f3a3b9f4479c) |
| pkgs/wlroots | [2019-01-03 14:14](https://github.com/swaywm/wlroots/commits/bcf48931db14f24fcd35a6999969864ca2539d32) |
| pkgs/sway-beta | [2019-01-03 09:52](https://github.com/swaywm/sway/commits/ee5013463467fb8eb6e08b0ebdf384ad2c1783a0) |
| pkgs/slurp | [2018-11-21 23:50](https://github.com/emersion/slurp/commits/95d8ec7e6b706961ffba3705033a9f57636aa65c) |
| pkgs/grim | [2018-12-20 05:19](https://github.com/emersion/grim/commits/4731977e9b0a55269f299225202006f86c8f1814) |
| pkgs/mako | [2018-11-24 14:32](https://github.com/emersion/mako/commits/a0e798a582bd7bcaacca249778f11124e6610ae9) |
| pkgs/kanshi | [2018-11-23 09:56](https://github.com/emersion/kanshi/commits/216a27f84c35fa649827db5a81baae3110b64d89) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2018-12-27 09:16](https://github.com/vilhalmer/oguri/commits/bc82b841e0d9667b266378818b9e026308756f75) |
| pkgs/waybar | [2018-12-28 15:06](https://github.com/Alexays/waybar/commits/afa1cc82875489092b6e53eb4a2e26528d6bd659) |
| pkgs/wayfire | [2019-01-03 13:38](https://github.com/WayfireWM/wayfire/commits/8bfc21f90ad93377ca59ccb3aa5e053025dd4660) |
| pkgs/wf-config | [2018-12-17 00:04](https://github.com/WayfireWM/wf-config/commits/6d3426e216ac62ffa035035f9c1bea074e184018) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 15:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 06:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2018-12-30 01:54](https://github.com/bugaevc/wl-clipboard/commits/41279f75afe1af21703111c633fd3efdf1f75744) |
| pkgs/wmfocus | [2018-12-13 15:02](https://github.com/svenstaro/wmfocus/commits/d828eb712debbec1ae3d67d7a571e6e6a1c004dd) |
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

