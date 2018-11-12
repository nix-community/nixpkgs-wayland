# "sway-on-ubuntu"

"sway-on-ubuntu" is a bad name, but so is "sway-on-ubuntu-via-nixpkgs".

**!!**: *Please do not file bugs against Sway when using these packages.*

## Walkthrough - NixGL + Sway on Ubuntu

This guide will walk you through running `sway` on Ubuntu via `nix` and `nixpkgs`.
In theory, this should work with a number of Ubuntu versions, but was tested with 18.10 under KVM.

At a high-level:
1. Install `nix`
2. Configure `nix` to use our binary cache where these packages are built against various versions of `nixpkgs`
3. Install `NixGL` allowing us to use OpenGL nix packages on non-NixOS distros
4. Install `sway-beta` from `nixpkgs` and this overlay
5. Configure `sway-beta` with some settings for this demo
5. Drop to a TTY and run it!

### Quick Version

If you'd like the quick version, you can run `./execute` (aka `/docs/sway-on-ubuntu/execute.sh`)
and then skip to the last step ("Run Sway").

### Full Version

#### Install Nix

Per the instructions on the NixOS Wiki: [Nix Installation Guide - Single User Install](https://nixos.wiki/wiki/Nix_Installation_Guide):
```bash
sudo apt update; sudo apt install curl git
sudo install -d -m755 -o $(id -u) -g $(id -g) /nix
curl https://nixos.org/nix/install | sh
source .nix-profile/etc/profile.d/nix.sh
```

(I recommend you logout/login here, so you don't need
to continue to source the nix profile in each shell.)


#### Install Cachix

`cachix` is a service that provides binary caching and a CLI
that enables easy uploading to and trusting of binary caches.

This will install `cachix` from a specific snapshot of `nixpkgs`
and make it available in your environment. **It will then trust
the binary cache that contains builds from this overlay.**

```bash
nix-env -iA cachix -f https://github.com/NixOS/nixpkgs/tarball/889c72032f8595fcd7542c6032c208f6b8033db6

# note that only the official NixOS cache is listed (cache.nixos.org)
cat ~/.config/nix

# ignore errors from this command (https://github.com/cachix/cachix/issues/148)
cachix use nixpkgs-wayland

# note that now the nixpkgs-wayland.cachix.org server is trusted
cat ~/.config/nix
```

This will cause future `nix` commands to check with our binary cache
instead of building everything from scratch. This repository is built against
`nixpkgs-unstable` which is what you're now using, so you shouldn't have to
build anything. Even if you did, `nix` effectively guarantees it will "just build"m,
assuming enough RAM, CPU, etc.

#### Enable the `nixpkgs-wayland` overlay

```bash
mkdir -p $HOME/.config/nixpkgs/overlays
git clone https://github.com/colemickens/nixpkgs-wayland.git $HOME/.config/nixpkgs/overlays/nixpkgs-wayland
```

#### Install NixGL and Sway

OpenGL enabled Nix applications on non-NixOS operating systems require
the use of a wrapper. I've added some summary details to the NixOS Wiki:
[Nixpkgs with OpenGL on non-NixOS](https://nixos.wiki/wiki/Nixpkgs_with_OpenGL_on_non-NixOS)

**Install NixGL and OpenGL drivers**

(Change the attribute to be installed per your GL vendor.)
```bash
nix-env -iE '(import (builtins.fetchurl { url = "https://raw.githubusercontent.com/guibou/nixGL/master/default.nix"; })).nixGLIntel
```

**Install Sway and a config file**

Install the default sway config:
```bash
nix-env -iA nixpkgs.sway-beta nixpkgs.dmenu
```

This will install `sway-beta` from `nixpkgs` (the channel that Nix is configured to follow out
of the box). In this case, `sway-beta` is actually a newer version coming from this overlay.

```bash
mkdir -p $HOME/.config/sway/config
wget 'https://raw.githubusercontent.com/swaywm/sway/master/config.in' \
  -O $HOME/.config/sway/config

# accomodate nested sway, remove missing BG, set $term
sed -i 's|Mod4|Mod1|g' ~/.config/sway/config
sed -i '/Sway_Wallpaper_Blue_1920x1080.png/d' ~/.config/sway/config
sed -i 's|urxvt|gnome-terminal|g' ~/.config/sway/config
```

##### Run Sway

Let's drop to a TTY and try sway. **Note, this will stop GDM and your current session!**

```bash
# from GNOME
sudo systemctl isolate multi-user.target

# on TTY
nixGLIntel sway
```

You can run `sway` under GNOME as well, but there are some oddities about where windows spawn.

