{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
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

  nativeBuildInputs = [ pkg-config meson ninja ] ++ lib.optional buildDocs scdoc;
  buildInputs = [
    cairo wayland wayland-protocols
    libxkbcommon
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
  ] ++ lib.optional (!buildDocs) "-Dman-pages=disabled";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Select a region in a Wayland compositor";
    homepage    = https://github.com/emersion/slurp;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
