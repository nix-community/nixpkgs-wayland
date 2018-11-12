#!/usr/bin/env bash

echo "---------------------------------------------"
echo "install nix"
sudo apt update -qqy; sudo apt install -qqy curl git
sudo install -d -m755 -o $(id -u) -g $(id -g) /nix
curl https://nixos.org/nix/install | sh
source .nix-profile/etc/profile.d/nix.sh

echo "---------------------------------------------"
echo "install cachix"
nix-env -iA cachix -f https://github.com/NixOS/nixpkgs/tarball/889c72032f8595fcd7542c6032c208f6b8033db6

echo "---------------------------------------------"
echo "use nixpkgs-wayland binary cache"
cachix use nixpkgs-wayland

echo "---------------------------------------------"
echo "activate `nixpkgs-wayland` overlay"
mkdir -p $HOME/.config/nixpkgs/overlays
if [[ ! -d "${HOME}/.config/nixpkgs/overlays/nixpkgs-wayland" ]]; then
  git clone https://github.com/colemickens/nixpkgs-wayland.git \
    $HOME/.config/nixpkgs/overlays/nixpkgs-wayland
fi

echo "---------------------------------------------"
echo "install NixGL, sway, dmenu"
nix-env -iE '(import (builtins.fetchurl { url = "https://raw.githubusercontent.com/guibou/nixGL/master/default.nix"; })).nixGLIntel'

nix-env -iA nixpkgs.sway-beta nixpkgs.dmenu

echo "---------------------------------------------"
echo "configuring sway"
mkdir -p $HOME/.config/sway/config
wget 'https://raw.githubusercontent.com/swaywm/sway/master/config.in' \
  -O $HOME/.config/sway/config

sed -i 's|Mod4|Mod1|g' ~/.config/sway/config
sed -i '/Sway_Wallpaper_Blue_1920x1080.png/d' ~/.config/sway/config
sed -i 's|urxvt|gnome-terminal|g' ~/.config/sway/config

echo "---------------------------------------------"
echo "done"
echo "---------------------------------------------"
echo "now run:"
echo " - sudo systemctl isolate multi-user.target (this will stop your GDM session)"
echo " - nixGLIntel sway"
echo "when in sway:"
echo " - `alt+d` starts `dmenu`"
echo " - `alt+enter` starts `gnome-terminal`"
echo "---------------------------------------------"
echo

