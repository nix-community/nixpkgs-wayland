# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`. They are published to the binary cache on Cachix. Usage instructions are available on the Cachix page: [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).



## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-08-11 00:18](https://github.com/nixos/nixpkgs-channels/commits/4557b9f1f50aa813ae673fe6fcd30ca872968947) |
| nixpkgs/nixpkgs-unstable | [2019-08-09 10:25](https://github.com/nixos/nixpkgs-channels/commits/c0e56afddbcf6002e87a5ab0e8e17f381e3aa9bd) |
| pkgs/cage | [2019-07-09 12:25](https://github.com/Hjdskes/cage/commits/016ef340d20febd15ae6d4fec2b6e9fba1422cee) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/grim | [2019-07-20 16:11](https://github.com/emersion/grim/commits/a9af6088d5e6eb31c4c12a659b4641e9398e33e9) |
| pkgs/i3status-rust | [2019-08-06 15:33](https://github.com/greshake/i3status-rust/commits/b506acd5fd77d0e553f0d8d43aaa620ae317d7e4) |
| pkgs/kanshi | [2019-06-07 20:15](https://github.com/emersion/kanshi/commits/76e9f4151f6d0880d32dbc57123e00eace1b0734) |
| pkgs/mako | [2019-07-25 05:31](https://github.com/emersion/mako/commits/7bbaf6352a1725f51c69afe9c4d276bbb293031c) |
| pkgs/oguri | [2019-08-10 16:09](https://github.com/vilhalmer/oguri/commits/2f260f8bb30a16e033394c5f9da8ebda461954de) |
| pkgs/redshift-wayland | [2019-04-17 23:13](https://github.com/minus7/redshift/commits/eecbfedac48f827e96ad5e151de8f41f6cd3af66) |
| pkgs/slurp | [2019-08-01 17:25](https://github.com/emersion/slurp/commits/cdab5c9a42b27bb7e0e7894bbd2675637a06ad7e) |
| pkgs/sway | [2019-08-09 00:59](https://github.com/swaywm/sway/commits/6200ecbc1dd85c3fb294c6a6618645b7f0a106c9) |
| pkgs/swaybg | [2019-08-08 23:03](https://github.com/swaywm/swaybg/commits/a8f109af90353369e7e2e689efe8ce06eb9c60ac) |
| pkgs/swayidle | [2019-08-07 23:53](https://github.com/swaywm/swayidle/commits/91c0c4a943342ddc7fbed0777a654ac2b83185ca) |
| pkgs/swaylock | [2019-08-04 06:15](https://github.com/swaywm/swaylock/commits/666ae950bc9c58b2676724e0d614f9018100fcca) |
| pkgs/waybar | [2019-08-08 10:25](https://github.com/Alexays/waybar/commits/e9b6380c1893d686992e0789d1dedc97f30ef779) |
| pkgs/waybox | [2019-06-19 22:09](https://github.com/wizbright/waybox/commits/bed7b707f24613dae334de6e7bd8f4e3313fa249) |
| pkgs/wayfire | [2019-08-03 14:43](https://github.com/WayfireWM/wayfire/commits/7f76400a469eecbe2bfff269e66bebe4d847c09c) |
| pkgs/wf-config | [2019-06-18 19:10](https://github.com/WayfireWM/wf-config/commits/f9c97d07cf9e669a346c83a3c1fce3e2d843bd51) |
| pkgs/wf-recorder | [2019-08-05 20:58](https://github.com/ammen99/wf-recorder/commits/20ab054b11d20c6d0da63917998af00c2f96d7c3) |
| pkgs/wl-clipboard | [2019-04-15 15:53](https://github.com/bugaevc/wl-clipboard/commits/c010972e6b0d2eb3002c49a6a1b5620ff5f7c910) |
| pkgs/wldash | [2019-08-09 22:01](https://github.com/kennylevinsen/wldash/commits/2bb0a2f29fc966aa609d9b8fd87aedc499b72bdb) |
| pkgs/wlroots | [2019-08-11 10:39](https://github.com/swaywm/wlroots/commits/94f65e354d09ded037e6ba724dc3eeed6d63778f) |
| pkgs/wtype | [2019-07-01 15:33](https://github.com/atx/wtype/commits/9752f420ffb1dd8b9cbc692d9f90cbe2cca343d9) |
| pkgs/xdg-desktop-portal-wlr | [2019-07-24 16:38](https://github.com/emersion/xdg-desktop-portal-wlr/commits/13076d0c10613e9ae73e61dd82b24ae9a6529667) |
<!--pkgs-->

</details>

## Usage

Continue reading for usage instructions on NixOS (only the `nixos-unstable` channel is supported!).

You can also use this [with Nix on Ubuntu. Please see the full walkthrough](docs/sway-on-ubuntu/).

### Usage (nixos-unstable)

This usage just utilizes [`overlay` functionality from `nixpkgs`]().

Note that when using the overlay, the module will automatically reference the correct
`sway` package since the newer package is overlayed ontop of `pkgs`.

```nix
{ config, lib, pkgs, ... }:
let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball url));
in
  {
    nixpkgs.overlays = [ waylandOverlay ];
    programs.sway.enable = true;
    programs.sway.extraPackages = with pkgs; [
      xwayland
      swaybg   # required by sway for controlling desktop wallpaper
      swayidle # used for controlling idle timeouts and triggers (screen locking, etc)
      swaylock # used for locking Wayland sessions

      waybar        # polybar-alike
      i3status-rust # simpler bar written in Rust

      gebaar-libinput  # libinput gestures utility
      glpaper          # GL shaders as wallpaper
      grim             # screen image capture
      kanshi           # dynamic display configuration helper
      mako             # notification daemon
      oguri            # animated background utility
      redshift-wayland # patched to work with wayland gamma protocol
      slurp            # screen area selection tool
      waypipe          # network transparency for Wayland
      wf-recorder      # wayland screenrecorder
      wl-clipboard     # clipboard CLI utilities
      wtype            # xdotool, but for wayland

      # TODO: more steps required to use this?
      xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
    ];
    environment.systemPackages = with pkgs; [
      # other compositors/window-managers
      waybox   # An openbox clone on Wayland
      bspwc    # Wayland compositor based on BSPWM
      cage     # A Wayland kiosk (runs a single app fullscreen)

      wayfire   # 3D wayland compositor
      wf-config # wayfire config manager
    ];
  }
```

### Usage (wlrobs)

OBS Studio Plugins don't really fit into any NixOS infrastructure, so we'll
follow the instructions provided by.

Note, these instructions can probably be simplified to just consume a latest snapshot of this repo, rather than cloning the repo at a point in time:

```bash
mkdir -p ~/.config/nixpkgs/overlays
git clone https://github.com/colemickens/nixpkgs-wayland ~/.config/nixpkgs/overlays/nixpkgs-wayland
nix-env -iA wlrobs
mkdir -p ~/.config/obs-studio
ln -s ~/.nix-profile/share/obs/obs-plugins ~/.config/obs-studio/plugins
```

### Quick Tips: `sway`

* Usage of display managers with `sway` is not supported upstream, you should run it from a TTY.
* You will likely want a default config file to place at `$HOME/.config/sway/config`. You can use the upstream default as a starting point: https://github.com/swaywm/sway/blob/master/config.in

## Development Guide

#### Building

1. Install `nix`.
2. Run `nix-build build.nix -A nixosUnstable` to build the packages against current `nixos-unstable`.
3. Run `nix-build build.nix -A nixpkgsUnstable` to build them against `nixpkgs-unstable`.

Do note that those channels are actually pinned in this repo. The update script will also update those
refs. Making sure the channels are up-to-date means that you will be building the packages that are going
to be requested by users on those channels (who are up-to-date on the channel).

#### Updating all packages

(Note, this currently only supports the repos hosted on GitHub. I need to switch to something else that
more intelligently caches the checkouts and pulls and checks for updates, rather than hitting an API that
won't work for SourceHut/Gitlab. However, the script should tell you at the end which repos (might) need 
manual updates.)

* `./update.sh`:
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * calls `nix-build build.nix -A nixosUnstable` to build all packages against `nixos-unstable`
  * calls `nix-build build.nix -A nixpkgsUnstable` to build all packages against `nixpkgs-unstable`
  * pushes to [nixpkgs-wayland on cachix](https://nixpkgs-wayland.cachix.org)
