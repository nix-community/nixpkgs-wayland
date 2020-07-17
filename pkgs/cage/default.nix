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

  patches = [
    (fetchpatch{url="https://github.com/Hjdskes/cage/pull/158.patch"; sha256="1piqg5r4b6zbr5xrgbj5ligza1jgbqh524vpb3f4yg7js8v8v8sm";})
  ];

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
