{ stdenv, fetchFromGitHub
, meson, pkgconfig, ninja
, wayland, wayland-protocols
, cairo, glm
, libevdev, freetype, libinput
, pixman, libxkbcommon, libdrm
, wlroots, wf-config
, libjpeg, libpng
, buildDocs ? true
#, egl, glesv2
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
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    # egl glesv2
    wayland wayland-protocols
    cairo glm
    libevdev freetype libinput
    pixman libxkbcommon libdrm
    wlroots wf-config
    libjpeg libpng
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
