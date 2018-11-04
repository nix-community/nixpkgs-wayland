# nixpkgs-wayland

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

## Overview

This is a `nixpkgs` overlay containing `HEAD` revisions of:

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| fmt | [2018-10-28 09:28](https://github.com/fmtlib/fmt/commits/36161284e246b400a7967df2de98cba1bf9f0fbe) |
| wlroots | [2018-11-01 13:52](https://github.com/swaywm/wlroots/commits/675cf8457ef3493112def366d7090731172ee872) |
| sway-beta | [2018-11-03 15:44](https://github.com/swaywm/sway/commits/d19648a304dd7c6731ce53a7b7a265019f5b4473) |
| slurp | [2018-10-24 12:37](https://github.com/emersion/slurp/commits/0dbd03991462397eb92bb40af712c837c898ebf1) |
| grim | [2018-10-24 12:39](https://github.com/emersion/grim/commits/61df6f0a9531520c898718874c460826bc7e2b42) |
| mako | [2018-11-03 07:23](https://github.com/emersion/mako/commits/d1e6585eb5c06f1e05c3ec77230a263d73cc103c) |
| wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| waybar | [2018-11-03 05:36](https://github.com/Alexays/waybar/commits/26182c222b6994666640ea0a89cfa97fbcf7229f) |
| wayfire | [2018-11-01 03:05](https://github.com/WayfireWM/wayfire/commits/f634aff42ae8a29794d3977675a09e72832f2414) |
| wf-config | [2018-10-22 00:05](https://github.com/WayfireWM/wf-config/commits/8f7046e6c67d4a277b0793b56ff6535f53997bc5) |
| redshift-wayland | [2018-09-01 12:25](https://github.com/minus7/redshift/commits/a2177ed9942477868ccc514372f32a0fbcbe189e) |
<!--pkgs-->

Auto-update script last run: <!--update-->2018-11-03 18:00<!--update-->.

Please open an issue if something is out of date.

## Example Usage

This is what I use in my configuration. It should work regardless of if you've
cloned this overlay locally.

```nix
{ ... }:
let
  nos = "https://github.com/colemickens/nix-overlay-sway/archive/master.tar.gz";
  swayOverlay =
    if builtins.pathExists /etc/nix-overlay-sway
    then (import /etc/nix-overlay-sway)
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

## Automation

* `./update.sh`
  * updates `./<pkg>/metadata.nix` with the latest commit+hash for each package.
  * updates `nixpkgs/metadata.nix` to `nixpkgs-channels#nixos-unstable`.

* `nix-build build.nix` builds all overlay packages with the nixpkgs specified in `./nixpkgs`.

* (Sidenote: [nixcfg/utils/azure](https://github.com/colemickens/nixcfg/tree/master/utils/azure) contains the script(s) used
  to upload the cached NARs to the binary mirror specified in this README.)

## Binary Cache (Cachix)

I'm now publishing these builds to [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).

```
nix-build build.nix | cachix push nixpkgs-wayland
```

## Notes

* This is meant to be used with (and is built [and partially tested] against) a nixpkgs near `nixos-unstable` or `nixos-18.09`.

