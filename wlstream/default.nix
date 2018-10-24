{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, libdrm, wayland, wayland-protocols
, ffmpeg_4, libpulseaudio
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "wlstream-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "atomnuker";
    repo = "wlstream";
    rev = version;
    sha256 = metadata.sha256;
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
