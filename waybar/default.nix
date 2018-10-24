{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols, sway, wlroots
, libpulseaudio, libinput, libnl, gtkmm3
, fmt, jsoncpp
, git
}:

stdenv.mkDerivation rec {
  name = "waybar-${version}";
  version = "a63650aa67351bc17d3c5b30a4ea151271edad16";

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = version;
    sha256 = "0mbipvbh79zx842gj0b2kpcvw9sd3wp360x2xyppirkrxw4dis0d";
  };

  patches = [
    ./waybar-gcc7.patch
    #./waybar-meson.patch
    ./waybar-prefix.patch
  ];

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    wayland wayland-protocols sway wlroots
    libpulseaudio libinput libnl gtkmm3
    git fmt jsoncpp
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
#    "-Dprefix=$(out)"
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
