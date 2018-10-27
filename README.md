# nix-overlay-sway

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

## Overview

This is a `nixpkgs` overlay containing `HEAD` revisions of:

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs | [2018-10-16T09:33:58Z](https://github.com/nixos/nixpkgs-channels/commits/45a419ab5a23c93421c18f3d9cde015ded22e712) |
| wlroots | [2018-10-22T12:51:06Z](https://github.com/swaywm/wlroots/commits/c55d1542fe30ea7872a60a732fa88028cd4d4b06) |
| sway-beta | [2018-10-27T09:23:57Z](https://github.com/swaywm/sway/commits/de250a523fb765531744d3a363693da9e9ac270b) |
| slurp | [2018-10-24T19:37:45Z](https://github.com/emersion/slurp/commits/0dbd03991462397eb92bb40af712c837c898ebf1) |
| grim | [2018-10-24T19:39:44Z](https://github.com/emersion/grim/commits/61df6f0a9531520c898718874c460826bc7e2b42) |
| wlstream | [2018-07-15T21:10:14Z](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| waybar | [2018-10-27T09:23:43Z](https://github.com/Alexays/waybar/commits/ed3e4b13959874a168d62885d8ea1c7617db43b8) |
| wayfire | [2018-10-27T08:31:50Z](https://github.com/WayfireWM/wayfire/commits/f2abe624c8f45d69ca51a7bf88933804589fb230) |
| wf-config | [2018-10-22T07:05:46Z](https://github.com/WayfireWM/wf-config/commits/8f7046e6c67d4a277b0793b56ff6535f53997bc5) |
<!--pkgs-->

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

