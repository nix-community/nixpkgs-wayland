let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/master.tar.gz";
    sha256 = "195mgl12xa3qdxj2qnqswff4ic205442ankz0mgfrlsvp3jpm4qr";
  };

  rev = "master";
  # 'rev' could be a git rev, to pin the overla.
  # if you pin, you should use a tool like `niv` maybe, but please consider trying flakes
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/${rev}.tar.gz";
  waylandOverlay = import (builtins.fetchTarball url);

  pkgs = import nixpkgs {
    overlays = [ waylandOverlay ];
  };
in
pkgs.waylandPkgs.waybar
