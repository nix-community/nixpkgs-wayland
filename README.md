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
| nixpkgs/nixos-unstable | [2019-03-06 05:31](https://github.com/nixos/nixpkgs-channels/commits/5d3fd3674a66c5b1ada63e2eace140519849c967) |
| nixpkgs/nixpkgs-unstable | [2019-03-05 04:34](https://github.com/nixos/nixpkgs-channels/commits/b36dc66bfea6b0a733cf13bed85d80462d39c736) |
| pkgs/wlroots | [2019-03-12 07:16](https://github.com/swaywm/wlroots/commits/408eca7dfa12eda0f1b0ec6050e99ee2e6a8f2b4) |
| pkgs/sway | [2019-03-12 19:52](https://github.com/swaywm/sway/commits/52a61671e93953a06b6b440ede5512e8fe45b35e) |
| pkgs/swayidle | [2019-02-16 08:43](https://github.com/swaywm/swayidle/commits/3e392e31c0684854a9a145cda1bd9a44c99ef24d) |
| pkgs/swaylock | [2019-02-12 14:27](https://github.com/swaywm/swaylock/commits/6b3be42264b9eaa8524ea4f0d93fbd1d82495d90) |
| pkgs/slurp | [2019-02-23 10:47](https://github.com/emersion/slurp/commits/0b5df0343d4e44802a0711089b0f7f0e014021d0) |
| pkgs/grim | [2019-02-20 05:18](https://github.com/emersion/grim/commits/6994df611f55a4089209fdd5ad8d9301e4fb0167) |
| pkgs/mako | [2019-03-08 00:53](https://github.com/emersion/mako/commits/9cf8a0335c811ccf4a6ea72be4c30aa646804365) |
| pkgs/kanshi | [2019-02-02 15:21](https://github.com/emersion/kanshi/commits/970267e400c21a6bb51a1c80a0aadfd1e6660a7b) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-02-19 06:19](https://github.com/vilhalmer/oguri/commits/59a51758f4b14f60113aad6ae4ebb92d80060ce5) |
| pkgs/waybar | [2019-03-12 03:41](https://github.com/Alexays/waybar/commits/cd131801996d002fc3e1b02cb750b6580ea4ba8c) |
| pkgs/wayfire | [2019-03-12 13:16](https://github.com/WayfireWM/wayfire/commits/ce81c6625b5b4d8a4ff3718bda94b6d13993c189) |
| pkgs/wf-config | [2019-02-13 07:49](https://github.com/WayfireWM/wf-config/commits/52a7963f8a77bfa98b657c76304d7ad515b69878) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 15:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 06:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-02-12 07:59](https://github.com/bugaevc/wl-clipboard/commits/a60fba0fad8399071bd36dbd2fb8fe0ef4cf6f11) |
| pkgs/i3status-rust | [2019-03-10 20:12](https://github.com/greshake/i3status-rust/commits/6e39780c7e191335f0d73eca7ccef140adc3a54a) |
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

