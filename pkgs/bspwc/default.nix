{ stdenv, fetchgit
, meson, ninja, pkgconfig, scdoc
, wlroots, wayland, wayland-protocols
, pixman, libxkbcommon
, libudev, mesa_noglu, libX11 # not mentioned in meson.build...
, wltrunk
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "bspwc-${version}";
  version = metadata.rev;

  src = fetchgit {
    url = "https://git.sr.ht/~bl4ckb0ne/bspwc";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja scdoc ];
  buildInputs = [
    wlroots wayland wayland-protocols wlroots wltrunk
    pixman libxkbcommon libudev mesa_noglu libX11
  ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Binary space partitioning wayland compositor";
    homepage    = "https://git.sr.ht/~bl4ckb0ne/bspwc";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
