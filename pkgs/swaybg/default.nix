{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
, cairo, wayland, wayland-protocols
, gdk-pixbuf, nonPngSupport ? true
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

  postPatch = ''
    sed -iE "0,/version: '.*',/ s//version: '${version}',/" meson.build
  '';

  nativeBuildInputs = [ pkg-config meson ninja ] ++ lib.optional buildDocs scdoc;

  buildInputs = [ cairo wayland wayland-protocols ] ++ lib.optional nonPngSupport gdk-pixbuf;

  mesonFlags = lib.optional nonPngSupport "-Dgdk-pixbuf=enabled"
    ++ lib.optional buildDocs "-Dman-pages=enabled";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Wallpaper tool for Wayland compositors";
    homepage    = https://github.com/swaywm/swaybg;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [  ];
  };
}
