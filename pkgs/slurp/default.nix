{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, cairo, wayland, wayland-protocols
, scdoc, buildDocs ? true
, libxkbcommon
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "slurp-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ stdenv.lib.optional buildDocs scdoc;
  buildInputs = [
    cairo wayland wayland-protocols
    libxkbcommon
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
  ] ++ stdenv.lib.optional (!buildDocs) "-Dman-pages=disabled";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Select a region in a Wayland compositor";
    homepage    = https://github.com/emersion/slurp;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
