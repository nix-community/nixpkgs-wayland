{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, libdrm, wayland, wayland-protocols
, ffmpeg_4, libpulseaudio
}:

stdenv.mkDerivation rec {
  name = "wlstream-${version}";
  version = "182076a94562b128c3a97ecc53cc68905ea86838";

  src = fetchFromGitHub {
    owner = "atomnuker";
    repo = "wlstream";
    rev = version;
    sha256 = "01qbcgfl3g9kfwn1jf1z9pdj3bvf5lmg71d1vwkcllc2az24bjqp";
  };

  patches = [ ./0001-meson-add-libdrm-dependency.patch ];
  enableParallelBuilding = true;
  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    libdrm wayland wayland-protocols
    ffmpeg_4 libpulseaudio
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
  ];

  meta = with stdenv.lib; {
    description = "wlroots-compatible screen capture application";
    homepage    = "https://github.com/atomnuker/wlstream";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
