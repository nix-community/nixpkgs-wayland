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
| nixpkgs/nixos-unstable | [2019-02-11 12:02](https://github.com/nixos/nixpkgs-channels/commits/36f316007494c388df1fec434c1e658542e3c3cc) |
| nixpkgs/nixpkgs-unstable | [2019-02-11 10:30](https://github.com/nixos/nixpkgs-channels/commits/1a88aa9e0cdcbc12acc5cbdc379c0804d208e913) |
| pkgs/wlroots | [2019-02-12 06:57](https://github.com/swaywm/wlroots/commits/d1409e338175753667097b5e9843dc0841a4df88) |
| pkgs/sway-beta | [2019-02-11 01:13](https://github.com/swaywm/sway/commits/fb4f29289fd8d1f94975e64fded6657222ed5390) |
| pkgs/swayidle | [2019-02-05 05:37](https://github.com/swaywm/swayidle/commits/85a680178d1b310788272edd8fb6bf86304cf721) |
| pkgs/swaylock | [2019-02-12 03:24](https://github.com/swaywm/swaylock/commits/ec78bb121f3bdf580ee97261e29f327cf57c0abb) |
| pkgs/slurp | [2019-02-12 12:24](https://github.com/emersion/slurp/commits/0d1186f03d7db8ee8ae870087920bb538aaa522c) |
| pkgs/grim | [2019-02-05 07:32](https://github.com/emersion/grim/commits/c00f545e0f514ed192337657be4854bbb5a7caef) |
| pkgs/mako | [2019-01-20 23:01](https://github.com/emersion/mako/commits/b30c786bdf8b90807e45ec0f52b292ee147ae1ff) |
| pkgs/kanshi | [2019-02-02 15:21](https://github.com/emersion/kanshi/commits/970267e400c21a6bb51a1c80a0aadfd1e6660a7b) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-01-19 14:57](https://github.com/vilhalmer/oguri/commits/88996939e8fb55c0a8d34596604660c87c585462) |
| pkgs/waybar | [2019-02-12 08:55](https://github.com/Alexays/waybar/commits/3e186734510a056e5949dfa9f0675dfcb711a99b) |
| pkgs/wayfire | [2019-02-11 11:44](https://github.com/WayfireWM/wayfire/commits/f2017397471a7595c903b12970ab51e7f26045d0) |
| pkgs/wf-config | [2019-02-11 11:42](https://github.com/WayfireWM/wf-config/commits/714ac10717bb7732db03225780395724deeb0f9f) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 15:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 06:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-02-12 07:59](https://github.com/bugaevc/wl-clipboard/commits/a60fba0fad8399071bd36dbd2fb8fe0ef4cf6f11) |
| pkgs/i3status-rust | [2019-02-02 06:04](https://github.com/greshake/i3status-rust/commits/550b60039a688d33df1439b7a003499fdd2ee90c) |
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

