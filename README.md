# nix-overlay-sway

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

## Overview

This is a `nixpkgs` overlay containing `HEAD` revisions of:
 - `wlroots` (<!--update-wlroots-->[commit 2018-10-22T12:51:06Z c55d1542fe30ea7872a60a732fa88028cd4d4b06](https://github.com/swaywm/wlroots/commits/c55d1542fe30ea7872a60a732fa88028cd4d4b06)<!--update-wlroots-->)
 - `sway-beta` (<!--update-sway-beta-->[commit 2018-10-27T05:58:37Z e4053191e6e62b454b96f2cd8b3b17eb2b9eadd1](https://github.com/swaywm/sway/commits/e4053191e6e62b454b96f2cd8b3b17eb2b9eadd1)<!--update-sway-beta-->)
 - `wlstream` (<!--update-wlstream-->[commit 2018-07-15T21:10:14Z 182076a94562b128c3a97ecc53cc68905ea86838](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838)<!--update-wlstream-->)
 - `grim` (<!--update-grim-->[commit 2018-10-24T19:39:44Z 61df6f0a9531520c898718874c460826bc7e2b42](https://github.com/emersion/grim/commits/61df6f0a9531520c898718874c460826bc7e2b42)<!--update-grim-->)
 - `slurp` (<!--update-slurp-->[commit 2018-10-24T19:37:45Z 0dbd03991462397eb92bb40af712c837c898ebf1](https://github.com/emersion/slurp/commits/0dbd03991462397eb92bb40af712c837c898ebf1)<!--update-slurp-->)
 - `waybar` (<!--update-waybar-->[commit 2018-10-27T07:35:47Z 16b01e10596bddb539cbae4267515eccd3e1ab0d](https://github.com/Alexays/waybar/commits/16b01e10596bddb539cbae4267515eccd3e1ab0d)<!--update-waybar-->)
 - `redshift-wayland` (`redshift` (with `minus7` patches)) (<!--update-redshift-wayland--><!--update-redshift-wayland-->)
 - `wayfire` (and `wf-config`) (<!--update-wayfire-->[commit 2018-10-27T08:31:50Z f2abe624c8f45d69ca51a7bf88933804589fb230](https://github.com/WayfireWM/wayfire/commits/f2abe624c8f45d69ca51a7bf88933804589fb230)<!--update-wayfire-->)

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

