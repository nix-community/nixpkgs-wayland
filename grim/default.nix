{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, cairo, libjpeg, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "grim-${version}";
  version = "97202f22003200edcc3fb5966ddc9b19cfe1c6f9";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "grim";
    rev = version;
    sha256 = "1cq8v4wiqjzg0p84f7l04ydbpirbplfm8zwmg2j2f28qcl5igylp";
  };

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ stdenv.lib.optional buildDocs [ scdoc ];
  buildInputs = [ cairo libjpeg wayland wayland-protocols ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Select a region in a Wayland compositor";
    homepage    = https://github.com/emersion/grim;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
