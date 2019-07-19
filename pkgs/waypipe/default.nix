{ stdenv, fetchgit
, meson, ninja, pkgconfig, python3
, wayland, wayland-protocols
, libffi, mesa_noglu
, lz4, zstd, ffmpeg_4, libva
, scdoc
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "waypipe-${version}";
  version = metadata.rev;

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/mstoeckl/waypipe";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja python3 scdoc ];
  buildInputs = [
    wayland wayland-protocols
    libffi mesa_noglu
    lz4 zstd ffmpeg_4 libva
  ];
  mesonFlags = [ "-Dauto_features=enabled" ];
  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Network transparency with Wayland";
    homepage    = "https://mstoeckl.com/notes/gsoc/blog.html";
    # license = ?
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
