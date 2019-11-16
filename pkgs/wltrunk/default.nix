{ stdenv, fetchgit
, meson, ninja, pkgconfig
, wlroots, wayland, wayland-protocols
, pixman, libxkbcommon
, libudev, mesa_noglu, libX11
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "wltrunk-${version}";
  version = metadata.rev;

  src = fetchgit {
    url = "https://git.sr.ht/~bl4ckb0ne/wltrunk";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    wlroots wayland wayland-protocols
    pixman libxkbcommon libudev mesa_noglu libX11
  ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "High-level Wayland compositor library based on wlroots";
    homepage    = "https://git.sr.ht/~bl4ckb0ne/wltrunk";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
