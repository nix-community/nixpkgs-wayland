# nix-overlay-sway

## Status

**Status**: Semi-functional

* `waybar` is tricky to build
* `redshift-wayland` needs to use some sort of `pythonOverride` thing I think.

## Overview

This is a `nixpkgs` overlay containing `HEAD` revisions of:
 - `wlroots`
 - `sway-beta`
 - `wlstream`
 - `grim`
 - `slurp`
 - (not working) `waybar`
 - (not working) `redshift-wayland` (`redshift` (with `minus7` patches))

Feel free to run the update script and send a PR if something is out-of-date.

## Automation

* `./update.sh` will update the various packages' `metadata.nix` files
  that contain their src `rev` and `sha256` values.

* `./update.sh` also updates the `nixpkgs/metadata.nix` to point to the latest
  `nixos-unstable`. This is used by `build.nix` to pre-build these packages
  against the latest `nixos-unstable` nixpkgs.

* `nix-build build.nix` will build all of the packages in the overlay against
  the versions of each dependency (specified in `./<dep>/metadata.nix`). This
  includes `nixpkgs`, plus each `pkg` in the overlay)

* [nixcfg](https://github.com/colemickens/nixcfg) contains the script(s) used
  to upload the cached NARs to the binary mirror specified in this README.

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

