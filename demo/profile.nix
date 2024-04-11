{ user }:
{ pkgs, inputs, ... }@args:
let
  inherit (inputs) home-manager;
in
{
  imports = [ "${home-manager}/nixos" ];

  nixpkgs.overlays = [ (import ../overlay.nix) ];

  # When this is enabled, the QEMU VM goes blank after boot
  networking.networkmanager.enable = true;

  fonts.packages = with pkgs; [
    dejavu_fonts # just a basic good font
    font-awesome_5
  ];

  # add sound support
  hardware.pulseaudio.enable = true;

  # setup the user's  home
  home-manager.users."${user}" = (import ./home/profile.nix) args;

  # Sway
  programs.sway.enable = true;
  programs.sway.extraSessionCommands = ''
    # Tell toolkits to use wayland
    export CLUTTER_BACKEND=wayland
    #export QT_QPA_PLATFORM=wayland-egl
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export SDL_VIDEODRIVER=wayland

    # Fix krita and other Egl-using apps
    export LD_LIBRARY_PATH=/run/opengl-driver/lib

    # Disable HiDPI scaling for X apps
    # https://wiki.archlinux.org/index.php/HiDPI#GUI_toolkits
    export GDK_SCALE=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=0
  '';

  # manage those with home-manager
  programs.sway.extraPackages = [ ];

  # Add the required groups for the user to get access
  users.extraUsers."${user}" = {
    extraGroups = [
      # allow sudo
      "wheel"
      "input"
      "tty"
      "audio"
      "video"
      # allow sway's setuid executable
      "sway"
      "networkmanager"
    ];
  };
}
