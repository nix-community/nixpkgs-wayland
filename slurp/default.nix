{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, cairo, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "slurp-${version}";
  version = "d907d308eb1eebf9b1be4a047edbc8f163bdd4b7";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = version;
    sha256 = "07aa3pwqm2a1cf60sipnzrdk1d7m0193jz22s15wqzxh93v3013l";
  };

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ stdenv.lib.optional buildDocs [ scdoc ];
  buildInputs = [
    cairo wayland wayland-protocols
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Select a region in a Wayland compositor";
    homepage    = https://github.com/emersion/slurp;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
