{ pkgs, ... }: {
  home.packages = with pkgs; [
    brightnessctl
    dmenu
    pavucontrol
    playerctl
    termite
    xdg_utils # needed for termite URL opening
    xwayland
  ] ++ (with waylandPkgs; [
    grim # screenshot CLI
    waybar
    kanshi # broken: display configurator
    mako # notification manager
    slurp # dimension-grabbing CLI, to use with grim
    swayidle # lock screen manager
  ]);

  programs.termite.enable = true;
  programs.termite.scrollbackLines = 10000;

  programs.firefox.enable = true;

  # FIXME: doesn't work yet
  xsession.enable = true;
  xsession.windowManager.command = "sway";

  xdg.enable = true;
  xdg.configFile."sway/config" = {
    source = pkgs.substituteAll {
      name = "sway-config";
      src = ./sway-config;
      wallpaper = ./wallpaper.jpg;
    };
  };

  xdg.configFile."chromium-flags.conf" = {
    source = pkgs.writeText "chromium-flags.conf" ''
      --force-device-scale-factor=1
    '';
  };

  gtk.enable = true;

  home.stateVersion = "23.11";
}
