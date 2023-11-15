{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      brightnessctl
      dmenu
      pavucontrol
      playerctl
      termite
      xdg_utils # needed for termite URL opening
      xwayland
    ]
    ++ (
      with waylandPkgs; [
        grim # screenshot CLI
        i3status-rust # menu bar
        kanshi # broken: display configurator
        mako # notification manager
        redshift-wayland # ???
        slurp # dimension-grabbing CLI, to use with grim
        swayidle # lock screen manager
        wlstream # screen recording CLI
      ]
    );

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
      i3status = ./i3status-rs.toml;
    };
    onChange = ''
      echo "Reloading sway"
      #FIXME: swaymsg reload
    '';
  };

  xdg.configFile."chromium-flags.conf" = {
    source = pkgs.writeText "chromium-flags.conf" ''
      --force-device-scale-factor=1
    '';
  };

  gtk.enable = true;
  gtk.gtk3.waylandSupport = true;
}
