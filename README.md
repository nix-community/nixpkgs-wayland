# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

This overlay is built and (somewhat) tested against `nixos-unstable`.
(See the usage section for other options if your system is not on `nixos-unstable`.)

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| fmt | [2018-11-03 16:51](https://github.com/fmtlib/fmt/commits/a23d592472b375a92df9c6040ccbe4b9065b5d6d) |
| wlroots | [2018-11-04 05:31](https://github.com/swaywm/wlroots/commits/d7b010024a4e46acb1eb5c54c1ce31dd816fb995) |
| sway-beta | [2018-11-05 12:31](https://github.com/swaywm/sway/commits/994c35e37527e754c6389db3e1c892d2937f2f7f) |
| slurp | [2018-10-24 12:37](https://github.com/emersion/slurp/commits/0dbd03991462397eb92bb40af712c837c898ebf1) |
| grim | [2018-10-24 12:39](https://github.com/emersion/grim/commits/61df6f0a9531520c898718874c460826bc7e2b42) |
| mako | [2018-11-03 07:23](https://github.com/emersion/mako/commits/d1e6585eb5c06f1e05c3ec77230a263d73cc103c) |
| kanshi | [2018-11-05 02:42](https://github.com/emersion/kanshi/commits/ed21acce0c52f7893c903f46b09b4a3b55e2c198) |
| wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| oguri | [2018-10-28 11:30](https://github.com/vilhalmer/oguri/commits/23bbd965f4744039c1c5a8e1d9604d6b8f6ab75f) |
| waybar | [2018-11-05 12:06](https://github.com/Alexays/waybar/commits/0933aad75f72d54d169bce2f0bd440876a414dc3) |
| wayfire | [2018-11-01 03:05](https://github.com/WayfireWM/wayfire/commits/f634aff42ae8a29794d3977675a09e72832f2414) |
| wf-config | [2018-10-22 00:05](https://github.com/WayfireWM/wf-config/commits/8f7046e6c67d4a277b0793b56ff6535f53997bc5) |
| redshift-wayland | [2018-09-01 12:25](https://github.com/minus7/redshift/commits/a2177ed9942477868ccc514372f32a0fbcbe189e) |
| bspwc | [2018-10-19 05:58](https://github.com/Bl4ckb0ne/bspwc/commits/6a8ba7bc17146544f6e0446f473ff290e77e3256) |
| wmfocus | [2018-11-01 11:17](https://github.com/svenstaro/wmfocus/commits/d6f5ff88b7fb5d2eedde3c5989ae49a656ac5adb) |
| i3status-rust | [2018-11-02 08:41](https://github.com/greshake/i3status-rust/commits/2b3ccf48721b3944281ee44a7e7562083471062d) |
| ripasso | [2018-10-25 16:45](https://github.com/cortex/ripasso/commits/a0e1d18320a17e3d6a1d5fc540591a139bcb63bf) |
<!--pkgs-->

Auto-update script last run: <!--update-->2018-11-05 13:59<!--update-->.

Please open an issue if something is out of date.

## Usage

This is what I use in my configuration. It should work regardless of if you've
cloned this overlay locally.

```nix
{ ... }:
let
  nos = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  swayOverlay =
    if builtins.pathExists /etc/nixpkgs-wayland
    then (import /etc/nixpkgs-wayland)
    else (import (builtins.fetchTarball nos));
in
{
  nixpkgs.overlays = [ swayOverlay ];

  environment.systemPackages = with pkgs; [
    sway-beta grim slurp wlstream
    redshift-wayland waybar
  ];
}
```

## Updates

* `./update.sh`
  * updates `./<pkg>/metadata.nix` with the latest commit+hash for each package.
  * updates `pkgs-*/metadata.nix` to their respective channels

* `nix-build build.nix` builds all overlay packages with certain revs of `nixpkgs`.


## Binary Cache

I'm now publishing these builds to
[`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).

```
nix-build build.nix | cachix push nixpkgs-wayland
```

The update script `./update.sh` also does this automatically.

### Usage

To use the cache:

```bash
# install cachix
nix-env -iA cachix -f https://github.com/NixOS/nixpkgs/tarball/889c72032f8595fcd7542c6032c208f6b8033db6

# trust and utilize the cache for this repo
cachix use nixpkgs-wayland
```

