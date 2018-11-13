# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

This overlay is built and (somewhat) tested against `nixos-unstable`.
(See the usage section for other options if your system is not on `nixos-unstable`.)

(Sister repositories: [nixpkgs-kubernetes](https://github.com/colemickens/nixpkgs-kubernetes), [nixpkgs-colemickens](https://github.com/colemickens/nixpkgs-colemickens))

## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2018-11-06 15:05](https://github.com/nixos/nixpkgs-channels/commits/6141939d6e0a77c84905efd560c03c3032164ef1) |
| pkgs/fmt | [2018-11-08 16:26](https://github.com/fmtlib/fmt/commits/1385050e267d645259d9fb66f016bdb2addb70a6) |
| pkgs/wlroots | [2018-11-12 13:15](https://github.com/swaywm/wlroots/commits/4aff85cc8e6f90e60522a7a830424e41a6f06b77) |
| pkgs/sway-beta | [2018-11-12 17:35](https://github.com/swaywm/sway/commits/27b930df24b59fdbc8996f86e702849e8a3678b1) |
| pkgs/slurp | [2018-10-24 12:37](https://github.com/emersion/slurp/commits/0dbd03991462397eb92bb40af712c837c898ebf1) |
| pkgs/grim | [2018-10-24 12:39](https://github.com/emersion/grim/commits/61df6f0a9531520c898718874c460826bc7e2b42) |
| pkgs/mako | [2018-11-11 13:05](https://github.com/emersion/mako/commits/ecc483a6a8da89f05d33010f3b49d372a186ae9a) |
| pkgs/kanshi | [2018-11-05 02:42](https://github.com/emersion/kanshi/commits/ed21acce0c52f7893c903f46b09b4a3b55e2c198) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2018-10-28 11:30](https://github.com/vilhalmer/oguri/commits/23bbd965f4744039c1c5a8e1d9604d6b8f6ab75f) |
| pkgs/waybar | [2018-11-11 04:41](https://github.com/Alexays/waybar/commits/3dc0f7ccf9cbfacf8c5eed13e19320bbd43288e8) |
| pkgs/wayfire | [2018-11-09 01:00](https://github.com/WayfireWM/wayfire/commits/7ee5a6524145584b38690bd9a75b23638db4152d) |
| pkgs/wf-config | [2018-10-22 00:05](https://github.com/WayfireWM/wf-config/commits/8f7046e6c67d4a277b0793b56ff6535f53997bc5) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-10-19 05:58](https://github.com/Bl4ckb0ne/bspwc/commits/6a8ba7bc17146544f6e0446f473ff290e77e3256) |
| pkgs/waybox | [2018-10-06 13:44](https://github.com/wizbright/waybox/commits/24669f24f6ce41f99088483f5c55c41498a57662) |
| pkgs/wmfocus | [2018-11-01 11:17](https://github.com/svenstaro/wmfocus/commits/d6f5ff88b7fb5d2eedde3c5989ae49a656ac5adb) |
| pkgs/i3status-rust | [2018-11-12 05:55](https://github.com/greshake/i3status-rust/commits/b198b11e4b02b1a3b20fbfca103c35040435ad08) |
<!--pkgs-->

</details><br/>

Auto-update script last run: <!--update-->2018-11-12 21:56<!--update-->.

## Usage

There are two ways to use this overlay on NixOS, depending on which
nixpkgs channel you follow.

You can also use this [with Nix on Ubuntu, there is a full walkthrough](docs/sway-on-ubuntu/README.md).

### Usage (nixos-unstable)

This usage just utilizes [`overlay` functionality from `nixpkgs`]().

Note that when using the overlay, the module will automatically reference the correct
`sway-beta` package, just as the environment packages come from `pkg`.

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
      grim slurp mako wlstream redshift-wayland # essentials
      waybar i3status-rust # optional bars
    ];
  }
```

### Usage (nixos-18.09)

Rather than maintaining an unknown number of backports from nixos-unstable to here
for supporting `nixos-18.09` users, these instructions will pull in select packages
from `nixos-unstable + this overlay` to your environment.

```nix
{ config, lib, pkgs, ... }:
let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandPkgs = import "${builtins.fetchTarball url}/build.nix";
in
  {
    nixpkgs.overlays = [ (self: super: { sway-beta = waylandPkgs.sway-beta; }) ];
    environment.systemPackages =
      with pkgs; [ vim git ] ++
      (with waylandPkgs; [
        grim slurp mako wlstream redshift-wayland # essentials
        waybar i3status-rust # optional bars
      ]);
  }
```

Note: The `sway-beta` module is not available to you. As a result, you need to manually
start sway with `dbus-launch` and you may have issues with `swaylock` due
to the missing security functionality.

```
dbus-launch --exit-with-session $(which sway-beta)
```


## Updates

* `./update.sh`:
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * calls `nix-build build.nix` to build all packages against `nixos-unstable`
  * pushes to [nixpkgs-wayland on cachix](https://nixpkgs-wayland.cachix.org)

## Binary Cache

Packages are built as described in the section above and are published to cachix.

See usage instructions at [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).

