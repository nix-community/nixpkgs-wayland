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
| nixpkgs/nixos-unstable | [2018-11-17 02:18](https://github.com/nixos/nixpkgs-channels/commits/80738ed9dc0ce48d7796baed5364eef8072c794d) |
| nixpkgs/nixpkgs-unstable | [2018-11-19 06:23](https://github.com/nixos/nixpkgs-channels/commits/3ae0407d3c9dbb7cdf049b69ebb32e62c39357e7) |
| pkgs/fmt | [2018-11-22 13:57](https://github.com/fmtlib/fmt/commits/e37d6a9840d504e3977ea193411decb4a3529d7d) |
| pkgs/wlroots | [2018-11-22 10:17](https://github.com/swaywm/wlroots/commits/c70b8f64b7f1ea0a603517c7e6852ef3743a483a) |
| pkgs/sway-beta | [2018-11-23 23:59](https://github.com/swaywm/sway/commits/d440468d2deb31d311564a5b796608136cf99e49) |
| pkgs/slurp | [2018-11-21 23:50](https://github.com/emersion/slurp/commits/95d8ec7e6b706961ffba3705033a9f57636aa65c) |
| pkgs/grim | [2018-11-21 23:44](https://github.com/emersion/grim/commits/9c2e630da91227f2d315381bcadee1116cb90229) |
| pkgs/mako | [2018-11-22 23:05](https://github.com/emersion/mako/commits/9c4fea743e5d6ed854ddcce9501cdd41e9ed5e04) |
| pkgs/kanshi | [2018-11-23 09:56](https://github.com/emersion/kanshi/commits/216a27f84c35fa649827db5a81baae3110b64d89) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2018-10-28 11:30](https://github.com/vilhalmer/oguri/commits/23bbd965f4744039c1c5a8e1d9604d6b8f6ab75f) |
| pkgs/waybar | [2018-11-23 10:31](https://github.com/Alexays/waybar/commits/2c2a0473f4ea8b933c73e912034aba9212ba0686) |
| pkgs/wayfire | [2018-11-20 13:17](https://github.com/WayfireWM/wayfire/commits/b0d5870183a20f22d30a153ebf0af1ac6662ba54) |
| pkgs/wf-config | [2018-10-22 00:05](https://github.com/WayfireWM/wf-config/commits/8f7046e6c67d4a277b0793b56ff6535f53997bc5) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-10-19 05:58](https://github.com/Bl4ckb0ne/bspwc/commits/6a8ba7bc17146544f6e0446f473ff290e77e3256) |
| pkgs/waybox | [2018-10-06 13:44](https://github.com/wizbright/waybox/commits/24669f24f6ce41f99088483f5c55c41498a57662) |
| pkgs/wl-clipboard | [2018-11-13 06:19](https://github.com/bugaevc/wl-clipboard/commits/48c2aed5ed7afe58100751f39e1b9ca05e946570) |
| pkgs/wmfocus | [2018-11-01 11:17](https://github.com/svenstaro/wmfocus/commits/d6f5ff88b7fb5d2eedde3c5989ae49a656ac5adb) |
| pkgs/i3status-rust | [2018-11-22 15:44](https://github.com/greshake/i3status-rust/commits/8d9a5d91fad5c049432c8972990a9751cef6a90c) |
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

