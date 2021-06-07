{ stdenv, lib, fetchFromGitHub
, meson, pkgconfig, ninja, cmake
, wayland, wayland-protocols
, cairo, glm
, libevdev, freetype, libinput
, pixman, libxkbcommon, libdrm
, libjpeg, libpng
, libGL, mesa
, libcap, xcbutilerrors, xcbutilwm, libxml2
, libuuid
, libseat, xorg, xwayland, doctest
, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "wayfire";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = version;
    sha256 = metadata.sha256;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgconfig meson ninja cmake
    doctest
  ];
  buildInputs = [
    # egl glesv2
    wayland wayland-protocols
    cairo glm
    libevdev freetype libinput
    pixman libxkbcommon libdrm
    libjpeg libpng
    libGL mesa
    libcap xcbutilerrors xcbutilwm libxml2
    libuuid
    libseat
    xwayland
    doctest
    xorg.xcbutilrenderutil
  ];
  mesonFlags = [
    "-Duse_system_wlroots=disabled"
    "-Duse_system_wfconfig=disabled"
    "-Dwlroots:logind-provider=systemd"
    "-Dwlroots:libseat=disabled"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "3D wayland compositor";
    homepage    = "https://wayfire.org/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
