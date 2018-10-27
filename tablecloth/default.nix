{ stdenv, fetchFromGitHub
, meson, pkgconfig, ninja
, wayland, wayland-protocols
, cairo, glm
, libevdev, freetype, libinput
, pixman, libxkbcommon, libdrm
, wlroots, wf-config
, libjpeg, libpng
, fmt, gtk3, gtkmm3, dbus_cplusplus
, buildDocs ? true
#, egl, glesv2
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "tablecloth";
  version = metadata.rev;

#  src = fetchFromGitHub {
#    owner = "topisani";
#    repo = "tablecloth";
#    rev = version;
#    sha256 = metadata.sha256;
#  };
  src = /home/cole/code/tablecloth;

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    # egl glesv2
    wayland wayland-protocols
    cairo glm
    libevdev freetype libinput
    pixman libxkbcommon libdrm
    wlroots wf-config
    libjpeg libpng
    fmt gtk3 gtkmm3 dbus_cplusplus
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "3D wayland compositor";
    homepage    = https://github.com/WayfireWM/wayfire;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
