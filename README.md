# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`. They are published to the binary cache on Cachix. Usage instructions are available on the Cachix page: [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).



## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-10-08 11:08](https://github.com/nixos/nixpkgs-channels/commits/07d4df5962625285bcc09b057b40001bfa32340d) |
| nixpkgs/nixpkgs-unstable | [2019-09-29 08:27](https://github.com/nixos/nixpkgs-channels/commits/bef773ed53f3d535792d7d7ff3ea50a3deeb1cdd) |
| pkgs/cage | [2019-08-27 16:14](https://github.com/Hjdskes/cage/commits/0fb513fb85eb5846eb598b91a0fc79dc16b5da36) |
| pkgs/gebaar-libinput | [2019-04-05 13:27](https://github.com/Coffee2CodeNL/gebaar-libinput/commits/c18c8bd73e79aaf1211bd88bf9cff808273cf6d6) |
| pkgs/grim | [2019-07-20 16:11](https://github.com/emersion/grim/commits/a9af6088d5e6eb31c4c12a659b4641e9398e33e9) |
| pkgs/i3status-rust | [2019-10-07 02:53](https://github.com/greshake/i3status-rust/commits/87222c02d764971d156e683a48a6e0f4b490f5cd) |
| pkgs/kanshi | [2019-09-20 09:59](https://github.com/emersion/kanshi/commits/5a30abdf0b3b39ea21298bea91f28924373e4f0b) |
| pkgs/mako | [2019-10-04 14:34](https://github.com/emersion/mako/commits/21d9f1e9deb85102ce6ab2c84bb055b02ea42772) |
| pkgs/oguri | [2019-09-03 02:54](https://github.com/vilhalmer/oguri/commits/5372ee49bb22b0370100be8589f3692da58602e3) |
| pkgs/redshift-wayland | [2019-08-24 15:20](https://github.com/minus7/redshift/commits/7da875d34854a6a34612d5ce4bd8718c32bec804) |
| pkgs/slurp | [2019-08-01 17:25](https://github.com/emersion/slurp/commits/cdab5c9a42b27bb7e0e7894bbd2675637a06ad7e) |
| pkgs/sway | [2019-10-08 16:42](https://github.com/swaywm/sway/commits/b4d785cf390033ee0839ef7b374e8edd554f6f9e) |
| pkgs/swaybg | [2019-08-08 23:03](https://github.com/swaywm/swaybg/commits/a8f109af90353369e7e2e689efe8ce06eb9c60ac) |
| pkgs/swayidle | [2019-08-27 15:18](https://github.com/swaywm/swayidle/commits/844dfde8538c1f55aaf254c18649d419bdff7a92) |
| pkgs/swaylock | [2019-09-12 20:33](https://github.com/swaywm/swaylock/commits/426e1ce93d1344414bd3fa0eb7cd50d7ca9ec075) |
| pkgs/waybar | [2019-10-07 07:23](https://github.com/Alexays/waybar/commits/5e4fdb15304f04132612c3a0c5724ae8ce099201) |
| pkgs/waybox | [2019-06-19 22:09](https://github.com/wizbright/waybox/commits/bed7b707f24613dae334de6e7bd8f4e3313fa249) |
| pkgs/wayfire | [2019-10-08 13:00](https://github.com/WayfireWM/wayfire/commits/833624fdcd610a9aea911a3e9cc30b13eac48691) |
| pkgs/wf-config | [2019-10-07 21:06](https://github.com/WayfireWM/wf-config/commits/c32580e04d0ebc93dbd439f77a2158b96cdc8dce) |
| pkgs/wf-recorder | [2019-10-04 19:18](https://github.com/ammen99/wf-recorder/commits/69fbe1b68274600f799cdbb16fe5948465d9a0da) |
| pkgs/wl-clipboard | [2019-10-03 12:16](https://github.com/bugaevc/wl-clipboard/commits/f3a45f69f7d14e7f7050bca4cbf6fea6697d1455) |
| pkgs/wdisplays | [2019-10-05 01:27](https://github.com/cyclopsian/wdisplays/commits/a3d3d13a017d4a5b461311d6d477e94b36f29990) |
| pkgs/wldash | [2019-10-05 20:43](https://github.com/kennylevinsen/wldash/commits/9233128b7c90537cb2157139a7ed1a3d0fbdfd8e) |
| pkgs/wlroots | [2019-10-08 16:46](https://github.com/swaywm/wlroots/commits/3b4824a2fe933a829b9710da069f8e067cf7e1a5) |
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
