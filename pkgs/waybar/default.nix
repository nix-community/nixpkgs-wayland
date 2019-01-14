{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols, sway, wlroots
, libpulseaudio, libinput, libnl, gtkmm3
, fmt, jsoncpp, libdbusmenu-gtk3
, glib
, git
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "waybar-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    wayland wayland-protocols sway wlroots
    libpulseaudio libinput libnl gtkmm3
    git fmt jsoncpp libdbusmenu-gtk3
    glib
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
    "-Dout=$out"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors.";
    homepage    = https://github.com/Alexays/Waybar;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}

