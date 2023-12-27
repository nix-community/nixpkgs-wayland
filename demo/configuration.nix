{ ... }:
{
  imports = [ (import ./profile.nix { user = "demo"; }) ];

  nix.trustedUsers = [
    "root"
    "@wheel"
  ];

  security.sudo.enable = true;

  users.users.demo = {
    uid = 1000;
    isNormalUser = true;
    password = "demo1234";
    #hashedPassword = "$6$3vp.8UtiX$XSiK9o.4OMB1e.NWH9TebK2GigdAX2HvH9w0XUnv9gU2a96b6zLQCRS7HNnApafK16K2puxWjnC0A.eriwpUD1";
    extraGroups =
      [
        # allow demo to administer the machine
        "wheel"
      ];
  };

  users.users.root = {
    password = "root1234";
  };

  services.xserver.enable = false;

  services.mingetty.helpLine = ''

       Welcome to the Sway demo

    login: demo
    password: demo1234

    Once logged-in, type `sway` to start the desktop environment.
  '';
}
