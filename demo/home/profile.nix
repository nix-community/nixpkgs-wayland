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
    i3status-rust # menu bar
    kanshi # broken: display configurator
    mako # notification manager
    redshift-wayland # ???
    slurp # dimension-grabbing CLI, to use with grim
    wlstream # screen recording CLI
  ]);

  programs.termite.enable = true;
  programs.termite.scrollbackLines = 10000;

  # FIXME: doesn't work yet
  xsession.enable = true;
  xsession.windowManager.command = "sway";

  xdg.enable = true;
  xdg.configFile."sway/config" = {
    source = ./sway-config;
    onChange = ''
      echo "Reloading sway"
      #FIXME: swaymsg reload
    '';
  };

  xdg.configFile."sway/status.toml" = {
    source = ./sway-status.toml;
    onChange = ''
      echo "Reloading sway"
      #FIXME: unable to retrive socket path
      #swaymsg reload
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
