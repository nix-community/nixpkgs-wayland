# nixpkgs-wayland

## Overview

Automated, pre-built packages for Wayland (sway/wlroots) tools for NixOS.

Packages from this overlay are regularly updated and built against `nixos-unstable` and `nixpkgs-unstable`.

(Sister repositories: [nixpkgs-kubernetes](https://github.com/colemickens/nixpkgs-kubernetes), [nixpkgs-colemickens](https://github.com/colemickens/nixpkgs-colemickens))

## Packages

<details><summary><em><b>Full list of Packages</b></em></summary>

<!--pkgs-->
| Attribute Name | Last Upstream Commit Time |
| -------------- | ------------------------- |
| nixpkgs/nixos-unstable | [2019-02-07 07:52](https://github.com/nixos/nixpkgs-channels/commits/6a0d2ff7c1d024914a3570b85f1c88df8930b471) |
| nixpkgs/nixpkgs-unstable | [2019-01-24 07:01](https://github.com/nixos/nixpkgs-channels/commits/11cf7d6e1ffd5fbc09a51b76d668ad0858a772ed) |
| pkgs/wlroots | [2019-02-06 05:39](https://github.com/swaywm/wlroots/commits/20d404a091fa92f56be4825bbaf89e4027fda154) |
| pkgs/sway-beta | [2019-02-07 00:41](https://github.com/swaywm/sway/commits/ec5da0ca5bad6a433f727499d68ac1352397f5aa) |
| pkgs/swayidle | [2019-02-05 05:37](https://github.com/swaywm/swayidle/commits/85a680178d1b310788272edd8fb6bf86304cf721) |
| pkgs/swaylock | [2019-02-05 17:09](https://github.com/swaywm/swaylock/commits/37280a92d936053785b3510e08d8bc4519057eca) |
| pkgs/slurp | [2019-02-06 06:26](https://github.com/emersion/slurp/commits/9ffec7e10da8f740f292b5e29c6433e8c4c075b4) |
| pkgs/grim | [2019-02-05 07:32](https://github.com/emersion/grim/commits/c00f545e0f514ed192337657be4854bbb5a7caef) |
| pkgs/mako | [2019-01-20 23:01](https://github.com/emersion/mako/commits/b30c786bdf8b90807e45ec0f52b292ee147ae1ff) |
| pkgs/kanshi | [2019-02-02 15:21](https://github.com/emersion/kanshi/commits/970267e400c21a6bb51a1c80a0aadfd1e6660a7b) |
| pkgs/wlstream | [2018-07-15 14:10](https://github.com/atomnuker/wlstream/commits/182076a94562b128c3a97ecc53cc68905ea86838) |
| pkgs/oguri | [2019-01-19 14:57](https://github.com/vilhalmer/oguri/commits/88996939e8fb55c0a8d34596604660c87c585462) |
| pkgs/waybar | [2019-02-07 04:34](https://github.com/Alexays/waybar/commits/aeec80f3753cf63399e172944dc0015213f9eedd) |
| pkgs/wayfire | [2019-02-05 06:46](https://github.com/WayfireWM/wayfire/commits/afc0b6dc28617731e1105e888d69c34ba491a32b) |
| pkgs/wf-config | [2019-02-05 07:43](https://github.com/WayfireWM/wf-config/commits/ecdb2f425ae569044797107130625e5aa87f7b86) |
| pkgs/redshift-wayland | [2018-11-07 12:03](https://github.com/minus7/redshift/commits/420d0d534c9f03abc4d634a7d3d7629caf29b4b6) |
| pkgs/bspwc | [2018-12-29 15:21](https://github.com/Bl4ckb0ne/bspwc/commits/e72ff641bd30d3db153d879cea1cffd149931546) |
| pkgs/waybox | [2018-11-27 06:44](https://github.com/wizbright/waybox/commits/482d0a92f5530a5cbab8b0b913b653d4503015c4) |
| pkgs/wl-clipboard | [2019-01-30 06:34](https://github.com/bugaevc/wl-clipboard/commits/7f3646611335e42b2b93c053792c9f6659c87cde) |
| pkgs/i3status-rust | [2019-02-02 06:04](https://github.com/greshake/i3status-rust/commits/550b60039a688d33df1439b7a003499fdd2ee90c) |
<!--pkgs-->

</details>

## Usage

Continue reading for usage instructions on NixOS (only the `nixos-unstable` channel is supported!).

You can also use this [with Nix on Ubuntu. Please see the full walkthrough](docs/sway-on-ubuntu/).

### Usage (nixos-unstable)

This usage just utilizes [`overlay` functionality from `nixpkgs`]().

Note that when using the overlay, the module will automatically reference the correct
`sway-beta` package since the newer package is overlayed ontop of `pkgs`.

```nix
{ config, lib, pkgs, ... }:
let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball url));
in
  {
    nixpkgs.overlays = [ waylandOverlay ];
    programs.sway-beta.enable = true;
    programs.sway-beta.extraPackages = with pkgs; [
      swayidle # used for controlling idle timeouts and triggers (screen locking, etc)
      swaylock # used for locking Wayland sessions

      waybar        # polybar-alike
      i3status-rust # simpler bar written in Rust

      grim     # screen image capture
      slurp    # screen are selection tool
      mako     # notification daemon
      wlstream # screen recorder
      oguri    # animated background utility
      kanshi   # dynamic display configuration helper
      redshift-wayland # patched to work with wayland gamma protocol
    ];
    environment.systemPackages = with pkgs; [
      # other compositors/window-managers
      wayfire  # 3D wayland compositor
      waybox   # An openbox clone on Wayland
      bspwc    # Wayland compositor based on BSPWM
    ];
  }
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

## Binary Cache

Packages are built as described in the section above and are published to cachix.

See usage instructions at [`nixpkgs-wayland` on cachix](https://nixpkgs-wayland.cachix.org).

