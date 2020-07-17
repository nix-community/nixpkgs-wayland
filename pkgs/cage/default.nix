{ stdenv, fetchFromGitHub, fetchpatch
, pkgconfig, meson, ninja, scdoc
, wayland, wayland-protocols
, wlroots, pixman, libxkbcommon, libudev, libGL, libX11
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "cage-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = "cage";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    scdoc
    wayland wayland-protocols
    wlroots pixman libxkbcommon libudev libGL libX11
  ];
  mesonFlags = [ "-Dxwayland=true" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Wayland kiosk";
    homepage    = "https://www.hjdskes.nl/projects/cage/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
