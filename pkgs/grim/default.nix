{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
, cairo, libjpeg, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "grim-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "grim";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkg-config meson ninja ] ++ lib.optional buildDocs scdoc;
  buildInputs = [ cairo libjpeg wayland wayland-protocols ];
  mesonFlags = [ "-Djpeg=enabled" ]
    ++ lib.optional buildDocs "-Dman-pages=enabled";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Grab images from a Wayland compositor";
    homepage    = "https://github.com/emersion/grim";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
