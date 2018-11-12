# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

This overlay is built and (somewhat) tested against `nixos-unstable`.
(See the usage section for other options if your system is not on `nixos-unstable`.)

(Sister repositories: [nixpkgs-kubernetes](https://github.com/colemickens/nixpkgs-kubernetes), [nixpkgs-colemickens](https://github.com/colemickens/nixpkgs-colemickens))

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| pkgs-unstable | [2018-11-06 15:05](https://github.com/nixos/nixpkgs-channels/commits/6141939d6e0a77c84905efd560c03c3032164ef1) |
| pkgs-18.09 | [2018-11-07 17:13](https://github.com/nixos/nixpkgs-channels/commits/a4c4cbb613cc3e15186de0fdb04082fa7e38f6a0) |
| fmt | [2018-11-08 16:26](https://github.com/fmtlib/fmt/commits/1385050e267d645259d9fb66f016bdb2addb70a6) |
| wlroots | [2018-11-10 06:38](https://github.com/swaywm/wlroots/commits/3181c4bec06d2fe51da052c0a08c8287725ec900) |
| sway-beta | [2018-11-11 13:16](https://github.com/swaywm/sway/commits/ee6b0ce24ae74cfae5d41985cacdff6065c8f534) |
| slurp | [2018-10-24 12:37](https://github.com/emersion/slurp/commits/0dbd03991462397eb92bb40af712c837c898ebf1) |
| grim | [2018-10-24 12:39](https://github.com/emersion/grim/commits/61df6f0a9531520c898718874c460826bc7e2b42) |
| mako | [2018-11-11 13:05](https://github.com/emersion/mako/commits/ecc483a6a8da89f05d33010f3b49d372a186ae9a) |
| kanshi | [2018-11-05 02:42](https://github.com/emersion/kanshi/commits/ed21acce0c52f7893c903f46b09b4a3b55e2c198) |
| wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| oguri | [2018-10-28 11:30](https://github.com/vilhalmer/oguri/commits/23bbd965f4744039c1c5a8e1d9604d6b8f6ab75f) |
| waybar | [2018-11-11 04:41](https://github.com/Alexays/waybar/commits/3dc0f7ccf9cbfacf8c5eed13e19320bbd43288e8) |
| wayfire | [2018-11-09 01:00](https://github.com/WayfireWM/wayfire/commits/7ee5a6524145584b38690bd9a75b23638db4152d) |
| wf-config | [2018-10-22 00:05](https://github.com/WayfireWM/wf-config/commits/8f7046e6c67d4a277b0793b56ff6535f53997bc5) |
| redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| bspwc | [2018-10-19 05:58](https://github.com/Bl4ckb0ne/bspwc/commits/6a8ba7bc17146544f6e0446f473ff290e77e3256) |
| waybox | [2018-10-06 13:44](https://github.com/wizbright/waybox/commits/24669f24f6ce41f99088483f5c55c41498a57662) |
| wmfocus | [2018-11-01 11:17](https://github.com/svenstaro/wmfocus/commits/d6f5ff88b7fb5d2eedde3c5989ae49a656ac5adb) |
| i3status-rust | [2018-11-09 14:22](https://github.com/greshake/i3status-rust/commits/47cb862c6e1763ae038d79915c2a4c28b073dd8e) |
<!--pkgs-->

Auto-update script last run: <!--update-->2018-11-12 03:20<!--update-->.

Please open an issue if something is out of date.

## Usage

There are two ways to use this overlay on NixOS, depending on which
nixpkgs channel you follow.

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
      with pkgs; [
        vim git
      ] ++
      (with swaypkgs; [
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

