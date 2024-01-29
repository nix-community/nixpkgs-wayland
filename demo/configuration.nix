{ ... }: {
  imports = [
    (import ./profile.nix { user = "demo"; })
  ];

  nix.settings.trusted-users = [ "root" "@wheel" ];

  security.sudo.enable = true;

  users.users.demo = {
    uid = 1000;
    isNormalUser = true;
    password = "demo1234";
    extraGroups = [
      # allow demo to administer the machine
      "wheel"
    ];
  };

  users.users.root = {
    password = "root1234";
  };

  services.xserver.enable = false;

  services.getty.helpLine = ''

       Welcome to the Sway demo

    login: demo
    password: demo1234

    Once logged-in, type `sway` to start the desktop environment.
  '';
}
