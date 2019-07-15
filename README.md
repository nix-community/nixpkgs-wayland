# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`. They are published to the binary cache on Cachix. Usage instructions are available on the Cachix page: [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).



## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-07-11 16:29](https://github.com/nixos/nixpkgs-channels/commits/1036dc664169b32613ec11b58cc1740c7511a340) |
| nixpkgs/nixpkgs-unstable | [2019-07-15 04:02](https://github.com/nixos/nixpkgs-channels/commits/eadc851051479c23ffaabe6b18d7aea8dac20001) |
| pkgs/cage | [2019-07-09 12:25](https://github.com/Hjdskes/cage/commits/016ef340d20febd15ae6d4fec2b6e9fba1422cee) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/grim | [2019-06-10 19:00](https://github.com/emersion/grim/commits/fb7261fbffac34bfce3387cb42e32d679d2b4e7b) |
| pkgs/i3status-rust | [2019-07-15 01:06](https://github.com/greshake/i3status-rust/commits/e47a83f1b1ffaab1fc0aa412c3fb99735af3158c) |
| pkgs/kanshi | [2019-06-07 20:15](https://github.com/emersion/kanshi/commits/76e9f4151f6d0880d32dbc57123e00eace1b0734) |
| pkgs/mako | [2019-07-13 07:54](https://github.com/emersion/mako/commits/ef15e8d4c0abc6396809bc18fa106a8c19afc312) |
| pkgs/oguri | [2019-07-14 16:47](https://github.com/vilhalmer/oguri/commits/5582689d76ae2e6295f8b8f51b4faafe469b85b4) |
| pkgs/redshift-wayland | [2019-04-17 23:13](https://github.com/minus7/redshift/commits/eecbfedac48f827e96ad5e151de8f41f6cd3af66) |
| pkgs/slurp | [2019-07-03 20:50](https://github.com/emersion/slurp/commits/6a9ac01100ecca05d221bea096bb088b376579c1) |
| pkgs/sway | [2019-07-14 15:13](https://github.com/swaywm/sway/commits/e3a3917d3afb66fc8ba3eebb7aed603d3b7ce844) |
| pkgs/swaybg | [2019-05-04 12:08](https://github.com/swaywm/swaybg/commits/25c6eaf15e64655385f01cbb98bffe28a862fe13) |
| pkgs/swayidle | [2019-07-11 14:18](https://github.com/swaywm/swayidle/commits/426338a39e5bc228e3b585a615a6b6f06e8f2d17) |
| pkgs/swaylock | [2019-06-28 14:27](https://github.com/swaywm/swaylock/commits/b1a7defa0087db7b984f568c79634316bb6bf1eb) |
| pkgs/waybar | [2019-07-15 11:38](https://github.com/Alexays/waybar/commits/7a2dee73770131ab9cf0d049972d8956807950b3) |
| pkgs/waybox | [2019-06-19 22:09](https://github.com/wizbright/waybox/commits/bed7b707f24613dae334de6e7bd8f4e3313fa249) |
| pkgs/wayfire | [2019-07-13 07:10](https://github.com/WayfireWM/wayfire/commits/765d626d178bf22d6e7708c8a8b41c092098da18) |
| pkgs/wf-config | [2019-06-18 19:10](https://github.com/WayfireWM/wf-config/commits/f9c97d07cf9e669a346c83a3c1fce3e2d843bd51) |
| pkgs/wf-recorder | [2019-06-24 15:08](https://github.com/ammen99/wf-recorder/commits/d40508331a6bdc5e2d20fa3804cbf40fc028390a) |
| pkgs/wl-clipboard | [2019-04-15 15:53](https://github.com/bugaevc/wl-clipboard/commits/c010972e6b0d2eb3002c49a6a1b5620ff5f7c910) |
| pkgs/wlroots | [2019-07-11 16:31](https://github.com/swaywm/wlroots/commits/6345000b929293a2917a1a08a6d2751020d36e3c) |
| pkgs/wtype | [2019-07-01 15:33](https://github.com/atx/wtype/commits/9752f420ffb1dd8b9cbc692d9f90cbe2cca343d9) |
| pkgs/xdg-desktop-portal-wlr | [2019-02-12 12:09](https://github.com/emersion/xdg-desktop-portal-wlr/commits/74ee43cf37e716d0119f441be96e2b3fc9838797) |
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

## Updates

* `./update.sh`:
  * updates `pkgs/<pkg>/metadata.nix` with the latest commit+hash for each package
  * updates `nixpkgs/<channel>/metadata.nix` per the upstream channel
  * calls `nix-build build.nix` to build all packages against `nixos-unstable`
  * calls `nix-build build.nixpkgs.nix` to build all packages against `nixpkgs-unstable`
  * pushes to [nixpkgs-wayland on cachix](https://nixpkgs-wayland.cachix.org)
