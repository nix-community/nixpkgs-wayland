# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

This overlay is built and (somewhat) tested against `nixos-unstable`.
(See the usage section for other options if your system is not on `nixos-unstable`.)

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| pkgs-unstable | [2018-11-06 15:05](https://github.com/nixos/nixpkgs-channels/commits/6141939d6e0a77c84905efd560c03c3032164ef1) |
| pkgs-18.09 | [2018-11-07 17:13](https://github.com/nixos/nixpkgs-channels/commits/a4c4cbb613cc3e15186de0fdb04082fa7e38f6a0) |
| fmt | [2018-11-08 16:26](https://github.com/fmtlib/fmt/commits/1385050e267d645259d9fb66f016bdb2addb70a6) |
| wlroots | [2018-11-09 12:45](https://github.com/swaywm/wlroots/commits/ca570fa63cb187ba078d95e0973da8562687673f) |
| sway-beta | [2018-11-08 17:07](https://github.com/swaywm/sway/commits/7fa7f4f48d17e0470c800b258061d188ceb705da) |
| slurp | [2018-10-24 12:37](https://github.com/emersion/slurp/commits/0dbd03991462397eb92bb40af712c837c898ebf1) |
| grim | [2018-10-24 12:39](https://github.com/emersion/grim/commits/61df6f0a9531520c898718874c460826bc7e2b42) |
| mako | [2018-11-03 07:23](https://github.com/emersion/mako/commits/d1e6585eb5c06f1e05c3ec77230a263d73cc103c) |
| kanshi | [2018-11-05 02:42](https://github.com/emersion/kanshi/commits/ed21acce0c52f7893c903f46b09b4a3b55e2c198) |
| wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| oguri | [2018-10-28 11:30](https://github.com/vilhalmer/oguri/commits/23bbd965f4744039c1c5a8e1d9604d6b8f6ab75f) |
| waybar | [2018-11-09 14:02](https://github.com/Alexays/waybar/commits/72226683263327fe22045081b3b9da05b9cd3e27) |
| wayfire | [2018-11-09 01:00](https://github.com/WayfireWM/wayfire/commits/7ee5a6524145584b38690bd9a75b23638db4152d) |
| wf-config | [2018-10-22 00:05](https://github.com/WayfireWM/wf-config/commits/8f7046e6c67d4a277b0793b56ff6535f53997bc5) |
| redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| bspwc | [2018-10-19 05:58](https://github.com/Bl4ckb0ne/bspwc/commits/6a8ba7bc17146544f6e0446f473ff290e77e3256) |
| waybox | [2018-10-06 13:44](https://github.com/wizbright/waybox/commits/24669f24f6ce41f99088483f5c55c41498a57662) |
| wmfocus | [2018-11-01 11:17](https://github.com/svenstaro/wmfocus/commits/d6f5ff88b7fb5d2eedde3c5989ae49a656ac5adb) |
| i3status-rust | [2018-11-09 14:22](https://github.com/greshake/i3status-rust/commits/47cb862c6e1763ae038d79915c2a4c28b073dd8e) |
| ripasso | [2018-10-25 16:45](https://github.com/cortex/ripasso/commits/a0e1d18320a17e3d6a1d5fc540591a139bcb63bf) |
<!--pkgs-->

Auto-update script last run: <!--update-->2018-11-09 17:13<!--update-->.

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

