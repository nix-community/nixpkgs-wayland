# nixpkgs-wayland

[![Build](https://github.com/nix-community/nixpkgs-wayland/actions/workflows/build.yaml/badge.svg)](https://github.com/nix-community/nixpkgs-wayland/actions/workflows/build.yaml)
[![Update](https://github.com/nix-community/nixpkgs-wayland/actions/workflows/update.yaml/badge.svg)](https://github.com/nix-community/nixpkgs-wayland/actions/workflows/update.yaml)
[![Advance](https://github.com/nix-community/nixpkgs-wayland/actions/workflows/advance.yaml/badge.svg)](https://github.com/nix-community/nixpkgs-wayland/actions/workflows/advance.yaml)

## overview

Automated, pre-built, (potentially) pre-release packages for Wayland (sway/wlroots) tools for NixOS (**nixos-unstable** channel).

These packages are auto-updated to the latest version available from their upstream source control. This means this overlay and package
set will often contain **unreleased** versions.

Community chat is on Matrix: [#nixpkgs-wayland:matrix.org](https://matrix.to/#/#nixpkgs-wayland:matrix.org). We are not on Libera.

Started by: [**@colemickens**](https://github.com/colemickens)
and co-maintained by [**@Artturin**](https://github.com/Artturin) (🙏).

<!-- TOC -->
- [overview](#overview)
- [Usage](#usage)
  - [Binary Cache](#binary-cache)
  - [Continuous Integration](#continuous-integration)
  - [Flake Usage](#flake-usage)
  - [Install for NixOS (non-flakes, manual import)](#install-for-nixos-non-flakes-manual-import)
  - [Install for non-NixOS users](#install-for-non-nixos-users)
- [Packages](#packages)
- [Tips](#tips)
    - [General](#general)
    - [`sway`](#sway)
    - [Nvidia Users](#nvidia-users)
- [Development Guide](#development-guide)
<!-- /TOC -->


## Usage

### Binary Cache

The [Cachix landing page for `nixpkgs-wayland`](https://nixpkgs-wayland.cachix.org) shows how to utilize the binary cache.

Packages from this overlay are regularly built against `nixos-unstable` and pushed to this cache.

### Continuous Integration

We have multiple CI jobs:
1. Update - this tries to advance nixpkgs and upgrade all packages. If it can successfully build them, the updates are push to master.
2. Advance - this tries to advance nixpkgs without touching the packages. This can help show when nixpkgs upgrades via `nixos-unstable` has advanced
   into a state where we are broken building against it.
3. Build - this just proves that `master` was working against `nixos-unstable` at the point in time captured by whatever is in `flake.lock` on `master`.

We don't have CI on Pull Requests, but I keep an eye on it after merging external contributions.

### Flake Usage

- Build and run [the Wayland-fixed up](https://github.com/obsproject/obs-studio/pull/2484) version of [OBS-Studio](https://obsproject.com/):
  ```
  nix shell "github:nix-community/nixpkgs-wayland#obs-studio" --command obs
  ```
- Build and run `waybar`:
  ```
  nix run "github:nix-community/nixpkgs-wayland#waybar"
  ```

* Use as an overlay or package set via flakes:

  ```nix
  {
    # ...
    inputs = {
      # ...
      nixpkgs-wayland  = { url = "github:nix-community/nixpkgs-wayland"; };

      # only needed if you use as a package set:
      nixpkgs-wayland.inputs.nixpkgs.follows = "cmpkgs";
      nixpkgs-wayland.inputs.master.follows = "master";
    };

    outputs = inputs: {
      nixosConfigurations."my-laptop-hostname" =
      let system = "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [({pkgs, config, ... }: {
          config = {
            nix = {
              # add binary caches
              binaryCachePublicKeys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
                # ...
              ];
              binaryCaches = [
                "https://cache.nixos.org"
                "https://nixpkgs-wayland.cachix.org"
                # ...
              ];
            };

            # use it as an overlay
            nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

            # or, pull specific packages (built against inputs.nixpkgs, usually `nixos-unstable`)
            environment.systemPackages = with pkgs; [
              inputs.nixpkgs-wayland.packages.${system}.waybar
            ];
          };
        })];
      };
    };
  }
  ```

### Install for NixOS (non-flakes, manual import)

If you are not using Flakes, then consult the [NixOS Wiki page on Overlays](https://nixos.wiki/wiki/Overlays). Also, you can expand this section for a more literal, direct example. If you do pin, use a tool like `niv` to do the pinning so that you don't forget and wind up stuck on an old version.

<details>

```nix
{ config, lib, pkgs, ... }:
let
  rev = "master"; # 'rev' could be a git rev, to pin the overlay.
  url = "https://github.com/nix-community/nixpkgs-wayland/archive/${rev}.tar.gz";
  waylandOverlay = (import "${builtins.fetchTarball url}/overlay.nix");
in
  {
    nixpkgs.overlays = [ waylandOverlay ];
    environment.systemPackages = with pkgs; [ wayvnc ];
    # ...
  }
```

You could write that to a file `./wayland.nix` next to your `configuration.nix` and then use it like so:

```nix
{ config, lib, pkgs, ... }:
  {
    # ...
    imports = [
      # ...
      ./wayland.nix
    ];
  }
```

</details>

### Install for non-NixOS users

Non-NixOS users have many options, but here are two explicitly:

1. Activate flakes mode, then just run them outright like the first example in this README.

2. See the following details block for an example of how to add `nixpkgs-wayland` as a user-level
   overlay and then install a package with `nix-env`.

<details>

1. There are two ways to activate an overlay for just your user:

   1. Add a new entry in ``~/.config/nixpkgs/overlays.nix`:
    ```nix
    let
      url = "https://github.com/nix-community/nixpkgs-wayland/archive/master.tar.gz";
    in
    [
      (import "${builtins.fetchTarball url}/overlay.nix")
    ]
    ```

   2. Add a new file under a dir, `~/.config/nixpkgs/overlays/nixpkgs-wayland.nix`:
    ```nix
    let
      url = "https://github.com/nix-community/nixpkgs-wayland/archive/master.tar.gz";
    in
      (import "${builtins.fetchTarball url}/overlay.nix")
    ```

  Note, this method does not pin `nixpkgs-wayland`. That's left to the reader. (Just use flakes...)

2. Then, `nix-env` will have access to the packages:

```nix
nix-env -iA neatvnc
```

</details>


## Packages

These packages were mostly recently built (and cached) against:

<!--pkgs-->
| Package | Description |
| --- | --- |
| [aml](https://github.com/any1/aml) | Another main loop |
| [cage](https://www.hjdskes.nl/projects/cage/) | A Wayland kiosk that runs a single, maximized application |
| [clipman](https://github.com/yory8/clipman) | A basic clipboard manager for Wayland, with support for persisting copy buffers after an application exits |
| [drm_info](https://github.com/ascent12/drm_info) | Small utility to dump info about DRM devices |
| [dunst](https://dunst-project.org/) | Lightweight and customizable notification daemon |
| [foot](https://codeberg.org/dnkl/foot/) | A fast, lightweight and minimalistic Wayland terminal emulator |
| [gebaar-libinput](https://github.com/Coffee2CodeNL/gebaar-libinput) | Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput |
| [glpaper](https://hg.sr.ht/~scoopta/glpaper) | Wallpaper program for wlroots based Wayland compositors such as sway that allows you to render glsl shaders as your wallpaper |
| [grim](https://github.com/emersion/grim) | Grab images from a Wayland compositor |
| [gtk-layer-shell](null) | A library to create panels and other desktop components for Wayland using the Layer Shell protocol |
| [i3status-rust](https://github.com/greshake/i3status-rust) | Very resource-friendly and feature-rich replacement for i3status |
| [imv](https://github.com/eXeC64/imv) | A command line image viewer for tiling window managers |
| [kanshi](https://sr.ht/~emersion/kanshi) | Dynamic display configuration tool |
| [lavalauncher](https://git.sr.ht/~leon_plickat/lavalauncher) | A simple launcher panel for Wayland desktops |
| [libvncserver_master](https://libvnc.github.io/) | VNC server library |
| [mako](https://wayland.emersion.fr/mako/) | A lightweight Wayland notification daemon |
| [neatvnc](https://github.com/any1/neatvnc) | A VNC server library |
| [obs-wlrobs](https://hg.sr.ht/~scoopta/wlrobs) | An obs-studio plugin that allows you to screen capture on wlroots based wayland compositors |
| [oguri](https://github.com/vilhalmer/oguri/) | A very nice animated wallpaper daemon for Wayland compositors |
| [rootbar](https://hg.sr.ht/~scoopta/rootbar) | A bar for Wayland WMs |
| [salut](https://gitlab.com/snakedye/salut) | A sleek notification daemon |
| [shotman](https://git.sr.ht/~whynothugo/shotman) | Uncompromising screenshot GUI for Wayland |
| [sirula](https://github.com/DorianRudolph/sirula) | Sirula (simple rust launcher) is an app launcher for wayland |
| [slurp](https://github.com/emersion/slurp) | Select a region in a Wayland compositor |
| [swaybg](https://github.com/swaywm/swaybg) | Wallpaper tool for Wayland compositors |
| [swayidle](https://github.com/swaywm/swayidle) | Idle management daemon for Wayland |
| [swaylock-effects](https://github.com/mortie/swaylock-effects) | Screen locker for Wayland |
| [swaylock](https://github.com/swaywm/swaylock) | Screen locker for Wayland |
| [sway-unwrapped](https://swaywm.org) | An i3-compatible tiling Wayland compositor |
| [waybar](https://github.com/alexays/waybar) | Highly customizable Wayland bar for Sway and Wlroots based compositors |
| [wayfire-unstable](https://wayfire.org/) | 3D wayland compositor |
| [waypipe](https://mstoeckl.com/notes/gsoc/blog.html) | A network proxy for Wayland clients (applications) |
| [wayprompt](https://git.sr.ht/~leon_plickat/wayprompt) | multi-purpose prompt tool for Wayland |
| [wayvnc](https://github.com/any1/wayvnc) | A VNC server for wlroots based Wayland compositors |
| [wdisplays](https://github.com/luispabon/wdisplays) | A graphical application for configuring displays in Wayland compositors |
| [wev](https://git.sr.ht/~sircmpwn/wev) | Wayland event viewer |
| [wf-recorder](https://github.com/ammen99/wf-recorder) | Utility program for screen recording of wlroots-based compositors |
| [wlay](https://github.com/atx/wlay) | Graphical output management for Wayland |
| [wldash](https://wldash.org) | Wayland launcher/dashboard |
| [wlfreerdp](http://www.freerdp.com/) | A Remote Desktop Protocol Client |
| [wlogout](https://github.com/ArtsyMacaw/wlogout) | A wayland based logout menu |
| [wlroots](https://gitlab.freedesktop.org/wlroots/wlroots/) | A modular Wayland compositor library |
| [wlr-randr](https://git.sr.ht/~emersion/wlr-randr) | An xrandr clone for wlroots compositors |
| [wlsunset](https://sr.ht/~kennylevinsen/wlsunset/) | Day/night gamma adjustments for Wayland |
| [wlvncc](https://github.com/any1/wlvncc) | A Wayland Native VNC Client |
| [wl-clipboard](https://github.com/bugaevc/wl-clipboard) | Command-line copy/paste utilities for Wayland |
| [wl-gammactl](https://github.com/mischw/wl-gammactl) | Contrast, brightness, and gamma adjustments for Wayland |
| [wofi](https://hg.sr.ht/~scoopta/wofi) | A launcher/menu program for wlroots based wayland compositors such as sway |
| [wshowkeys](https://github.com/ammgws/wshowkeys) | Displays keys being pressed on a Wayland session |
| [wtype](https://github.com/atx/wtype) | xdotool type for wayland |
| [xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr) | xdg-desktop-portal backend for wlroots |
<!--pkgs-->

</details>

## Tips

#### General

- I recommend using [`home-manager`](https://github.com/rycee/home-manager/)!
- It has modules and options for:
  - `sway`
  - `waybar`
  - `obs` and plugins!
  - more!

#### `sway`

- You will likely want a default config file to place at `$HOME/.config/sway/config`. You can use the upstream default as a starting point: https://github.com/swaywm/sway/blob/master/config.in
- If you start `sway` from a raw TTY, make sure you use `exec sway` so that if sway crashes, an unlocked TTY is not exposed.

#### Nvidia Users

- Everything should just work now (aka, wlroots/sway don't need patching).
- This is a known-good working config, at least at one point in time:
  [mixins/nvidia.nix@ccd992](https://github.com/cole-mickens/nixcfg/blob/cdd9929d5d36ce5b4d64cf80bdeb1df3f2cba332/mixins/nvidia.nix)

## Development Guide

- Use `direnv` + `nix-direnv` (or if you can't, `nix develop`, (or if you can't, `nix-shell`)).
- `./update.sh`:
  - updates flake inputs
  - updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  - calls `nix-build-uncached ... packages.nix` to build uncached packages (see: [nix-build-uncached](https://github.com/Mic92/nix-build-uncached))
  - pushes to ["nixpkgs-wayland" on cachix](https://nixpkgs-wayland.cachix.org)

If for some reason the overlay isn't progressing and you want to help, just clone the repo, run `nix-shell --command ./update.sh`
and start fixing issues in the package definitions. Sometimes you might need to edit `default.nix` to change the version
of `wlroots` a certain package uses.
