# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`. They are published to the binary cache on Cachix. Usage instructions are available on the Cachix page: [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).



## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-06-06 13:30](https://github.com/nixos/nixpkgs-channels/commits/1dc26c32edffdb73adb0a82b430834d3404aa8f3) |
| nixpkgs/nixpkgs-unstable | [2019-05-29 03:19](https://github.com/nixos/nixpkgs-channels/commits/61f0936d1cd73760312712615233cd80195a9b47) |
| pkgs/alacritty | [2019-06-07 22:09](https://github.com/jwilm/alacritty/commits/527dc8f564823d3dd01f79f22614271c7f3bc518) |
| pkgs/cage | [2019-06-03 17:55](https://github.com/Hjdskes/cage/commits/1ecba7e67cfb8655d12b0b250b92eff71886bd4f) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/grim | [2019-06-04 20:00](https://github.com/emersion/grim/commits/e96ae285934aa6aae0ee4f97d35f516daf105afc) |
| pkgs/i3status-rust | [2019-06-05 22:34](https://github.com/greshake/i3status-rust/commits/c81c439943af8ed72dba33c4e25172d7abd99b84) |
| pkgs/kanshi | [2019-06-07 20:15](https://github.com/emersion/kanshi/commits/76e9f4151f6d0880d32dbc57123e00eace1b0734) |
| pkgs/mako | [2019-06-04 16:08](https://github.com/emersion/mako/commits/2970ef24f4c67db61874e70827bf616e7145d3e7) |
| pkgs/oguri | [2019-05-26 22:46](https://github.com/vilhalmer/oguri/commits/f766b6d1f908e4b07765295892843cd8ceb7497a) |
| pkgs/redshift-wayland | [2019-04-17 23:13](https://github.com/minus7/redshift/commits/eecbfedac48f827e96ad5e151de8f41f6cd3af66) |
| pkgs/slurp | [2019-06-03 18:35](https://github.com/emersion/slurp/commits/0bd59daa7a3c701ec8f23bc5b4b77ea1df149a01) |
| pkgs/sway | [2019-06-07 07:15](https://github.com/swaywm/sway/commits/9bfbb0dd49d4c473dfc5b3f89fb1469b416ea082) |
| pkgs/swaybg | [2019-05-04 12:08](https://github.com/swaywm/swaybg/commits/25c6eaf15e64655385f01cbb98bffe28a862fe13) |
| pkgs/swayidle | [2019-05-23 13:10](https://github.com/swaywm/swayidle/commits/5e7bd5bd21010cb5723acdf449edb341e9880ae2) |
| pkgs/swaylock | [2019-05-23 06:43](https://github.com/swaywm/swaylock/commits/a9b274eb6c63397273515151324add022a3db2a9) |
| pkgs/waybar | [2019-06-07 13:08](https://github.com/Alexays/waybar/commits/648eecdd8330af91ad31cfec199a0da5bd563766) |
| pkgs/waybox | [2018-11-27 14:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wayfire | [2019-05-22 12:55](https://github.com/WayfireWM/wayfire/commits/188dfd489ccb5e7889e998fded4070dafe922dda) |
| pkgs/wf-config | [2019-05-10 12:27](https://github.com/WayfireWM/wf-config/commits/dd6f49522c7f6f4a303d9318cddf67ff38829b0a) |
| pkgs/wf-recorder | [2019-05-22 13:40](https://github.com/ammen99/wf-recorder/commits/43fb1c25a80ac1e498b4e4db9c28ebd3def5804a) |
| pkgs/wl-clipboard | [2019-04-15 15:53](https://github.com/bugaevc/wl-clipboard/commits/c010972e6b0d2eb3002c49a6a1b5620ff5f7c910) |
| pkgs/wlroots | [2019-06-07 13:06](https://github.com/swaywm/wlroots/commits/d201fc3506f70f5417b6dc00c8093c14db80b52a) |
| pkgs/wtype | [2019-05-30 23:01](https://github.com/atx/wtype/commits/157ae8fb7bc4235d1dd87dde479eecfc2a17665f) |
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
