# nix-overlay-sway

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

## Overview

This is a `nixpkgs` overlay containing `HEAD` revisions of:

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| wlroots | [2018-10-27 03:20](https://github.com/swaywm/wlroots/commits/266b3df6781409facd679d680f7335e156446d17) |
| sway-beta | [2018-10-27 02:23](https://github.com/swaywm/sway/commits/de250a523fb765531744d3a363693da9e9ac270b) |
| slurp | [2018-10-24 12:37](https://github.com/emersion/slurp/commits/0dbd03991462397eb92bb40af712c837c898ebf1) |
| grim | [2018-10-24 12:39](https://github.com/emersion/grim/commits/61df6f0a9531520c898718874c460826bc7e2b42) |
| wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| waybar | [2018-10-27 02:23](https://github.com/Alexays/waybar/commits/ed3e4b13959874a168d62885d8ea1c7617db43b8) |
| wayfire | [2018-10-27 01:31](https://github.com/WayfireWM/wayfire/commits/f2abe624c8f45d69ca51a7bf88933804589fb230) |
| wf-config | [2018-10-22 00:05](https://github.com/WayfireWM/wf-config/commits/8f7046e6c67d4a277b0793b56ff6535f53997bc5) |
| redshift-wayland | [2018-09-01 12:25](https://github.com/minus7/redshift/commits/a2177ed9942477868ccc514372f32a0fbcbe189e) |
<!--pkgs-->

Auto-update script last run: <!--update-->2018-10-27 04:37<!--update-->.

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

## Binary Cache

I run a cache. It sometimes, might contain packages as built by the process described above.

* cache: `https://nixcache.cluster.lol`
* public key: `nixcache.cluster.lol-1:DzcbPT+vsJ5LdN1WjWxJPmu+BeU891mgsrRa2X+95XM=`

```
--extra-binary-caches "https://nixcache.cluster.lol https://cache.nixos.org"
--option trusted-public-keys "nixcache.cluster.lol-1:DzcbPT+vsJ5LdN1WjWxJPmu+BeU891mgsrRa2X+95XM= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="'
```

## Notes

* This is meant to be used with a nixpkgs near `nixos-unstable`.

