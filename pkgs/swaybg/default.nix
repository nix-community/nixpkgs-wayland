{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, cairo, wayland, wayland-protocols
, gdk_pixbuf, nonPngSupport ? true
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "swaybg";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaybg";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [ cairo wayland wayland-protocols ] ++ stdenv.lib.optional nonPngSupport gdk_pixbuf;

  mesonFlags = stdenv.lib.optional nonPngSupport "-Dgdk-pixbuf=enabled"
    ++ stdenv.lib.optional buildDocs "-Dman-pages=enabled";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Wallpaper tool for Wayland compositors";
    homepage    = https://github.com/swaywm/swaybg;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [  ];
  };
}
