{ stdenv
, lib
, fetchFromGitHub
, meson
, pkg-config
, ninja
, cmake
, wayland
, wayland-protocols
, cairo
, glm
, libevdev
, freetype
, libinput
, pixman
, libxkbcommon
, libdrm
, libjpeg
, libpng
, libGL
, mesa
, libcap
, xcbutilerrors
, xcbutilwm
, libxml2
, libuuid
, seatd
, xorg
, xwayland
, doctest
, pango
, vulkan-headers
, vulkan-loader
, glslang
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wayfire";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = version;
    inherit (metadata) sha256;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    doctest
  ];
  buildInputs = [
    # egl glesv2
    wayland
    wayland-protocols
    cairo
    glm
    libevdev
    freetype
    libinput
    pixman
    libxkbcommon
    libdrm
    libjpeg
    libpng
    libGL
    mesa
    libcap
    xcbutilerrors
    xcbutilwm
    libxml2
    libuuid
    seatd
    xwayland
    doctest
    xorg.xcbutilrenderutil
    pango
    vulkan-headers
    vulkan-loader
    glslang
  ];
  mesonFlags = [
    "-Duse_system_wlroots=disabled"
    "-Duse_system_wfconfig=disabled"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "3D wayland compositor";
    homepage = "https://wayfire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
