# nix-overlay-sway

## NOTE

OCT 23: This is non-functional. I'm working on it right now. Help me in #nixos. :)

## Overview

This is a `nixpkgs` overlay containing `HEAD` revisions of:
 - `wlroots`
 - `sway-beta`
 - `wlstream`
 - `grim`
 - `slurp`
 - `waybar`
 - `redshift-wayland` (`redshift` (with `minus7` patches))

Feel free to run the update script and send a PR if something is out-of-date.

## Updating

`./update.sh` will update the various packages' `metadata.nix` files
that contain their src `rev` and `sha256` values.

## Binary Cache

I run a cache. It sometimes contains these packages against `nixos-unstable`.

* cache: `https://nixcache.cluster.lol`
* public key: `nixcache.cluster.lol-1:DzcbPT+vsJ5LdN1WjWxJPmu+BeU891mgsrRa2X+95XM=`

```
--extra-binary-caches "https://nixcache.cluster.lol https://cache.nixos.org"
--option trusted-public-keys "nixcache.cluster.lol-1:DzcbPT+vsJ5LdN1WjWxJPmu+BeU891mgsrRa2X+95XM= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="'
```

## Notes

* This is meant to be used with a nixpkgs near `nixos-unstable`

