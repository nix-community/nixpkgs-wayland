{ pkgs, ... }@args:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz;
in
{

  imports = [
    "${home-manager}/nixos"
  ];

  nixpkgs.overlays = [ (import ../.) ];

  networking.networkmanager.enable = true;

  fonts.fonts = with pkgs; [
    dejavu_fonts    # just a basic good fond
    font-awesome_5  # needed by i3status-rust
  ];

  # add sound support
  hardware.pulseaudio.enable = true;

  # to allow control of the screen brightness
  hardware.brightnessctl.enable = true;

  # setup the demo home
  home-manager.users.demo = (import ./home/profile.nix) args;

  programs.ssh.startAgent = false; # use gpg-agent instead
  programs.gnupg = {
    agent.enable = true;
    agent.enableSSHSupport = true;
    dirmngr.enable = true;
  };

  # Sway
  programs.sway-beta.enable = true;
  programs.sway-beta.extraSessionCommands = ''
    # Tell toolkits to use wayland
    export CLUTTER_BACKEND=wayland
    export QT_QPA_PLATFORM=wayland-egl
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
  programs.sway-beta.extraPackages = [];

  # Sway doesn't support login managers
  services.xserver.enable = false;

  # Create the demo user with proper permissions
  users.extraUsers.demo = {
    password = "demo";
    extraGroups = [
      "wheel"
      "input"
      "tty"
      "audio"
      "video"
      # allow sway's setuid executable
      "sway"
      "networkmanager"
      # allow sudo
      "wheel"
    ];
    uid = 3000;
  };

  security.sudo.enable = true;

}
