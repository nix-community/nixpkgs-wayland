{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, libdrm, wayland, wayland-protocols
, ffmpeg_4, libpulseaudio
, fetchpatch
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
  patches = [
    (fetchpatch {
      url = "https://github.com/atomnuker/wlstream/pull/4/commits/23e43186fd1ebeb553c89317f69613e67b266cd3.patch";
      sha256 = "1n5vv2cf1h0q920sxd1ksyfn0ld7f9h72mpp8478ln0r3hjz4f1k";
    })
  ];

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
