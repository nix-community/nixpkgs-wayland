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
| nixpkgs/nixos-unstable | [2019-02-26 03:26](https://github.com/nixos/nixpkgs-channels/commits/1233c8d9e9bc463899ed6a8cf0232e6bf36475ee) |
| nixpkgs/nixpkgs-unstable | [2019-02-28 19:22](https://github.com/nixos/nixpkgs-channels/commits/6e5caa3f8ac48750233ef82a94825be238940825) |
| pkgs/wlroots | [2019-03-01 00:20](https://github.com/swaywm/wlroots/commits/5445d8aad0112dab3ed798c39bf6b22f2a4eebd1) |
| pkgs/sway-beta | [2019-03-01 07:25](https://github.com/swaywm/sway/commits/f98410c090c995d491ba538850b792c763407583) |
| pkgs/swayidle | [2019-02-16 08:43](https://github.com/swaywm/swayidle/commits/3e392e31c0684854a9a145cda1bd9a44c99ef24d) |
| pkgs/swaylock | [2019-02-12 14:27](https://github.com/swaywm/swaylock/commits/6b3be42264b9eaa8524ea4f0d93fbd1d82495d90) |
| pkgs/slurp | [2019-02-23 10:47](https://github.com/emersion/slurp/commits/0b5df0343d4e44802a0711089b0f7f0e014021d0) |
| pkgs/grim | [2019-02-20 05:18](https://github.com/emersion/grim/commits/6994df611f55a4089209fdd5ad8d9301e4fb0167) |
| pkgs/mako | [2019-02-20 14:00](https://github.com/emersion/mako/commits/e3a69aa4017d6cb64a270fcc2e708c98cd9d2b39) |
| pkgs/kanshi | [2019-02-02 15:21](https://github.com/emersion/kanshi/commits/970267e400c21a6bb51a1c80a0aadfd1e6660a7b) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-02-19 06:19](https://github.com/vilhalmer/oguri/commits/59a51758f4b14f60113aad6ae4ebb92d80060ce5) |
| pkgs/waybar | [2019-03-01 08:12](https://github.com/Alexays/waybar/commits/f47492c3716f93c23c67d0015a42a184097b2a4e) |
| pkgs/wayfire | [2019-02-28 08:12](https://github.com/WayfireWM/wayfire/commits/38c071e547b2774967224654ee8459fc9d10d461) |
| pkgs/wf-config | [2019-02-13 07:49](https://github.com/WayfireWM/wf-config/commits/52a7963f8a77bfa98b657c76304d7ad515b69878) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 15:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 06:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-02-12 07:59](https://github.com/bugaevc/wl-clipboard/commits/a60fba0fad8399071bd36dbd2fb8fe0ef4cf6f11) |
| pkgs/i3status-rust | [2019-02-15 10:03](https://github.com/greshake/i3status-rust/commits/2dc958995834b529a245c22c510b57d5c928c747) |
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

