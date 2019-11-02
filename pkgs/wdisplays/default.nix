{stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, gtk3, epoxy
, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wdisplays";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = "wdisplays";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ stdenv.lib.optional buildDocs scdoc;
  buildInputs = [ gtk3 epoxy wayland wayland-protocols ];
  mesonFlags = [ "-Dauto_features=enabled" ]
    ++ stdenv.lib.optional (!buildDocs) "-Dman-pages=disabled";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GUI display configurator for wlroots compositors";
    homepage    = "https://github.com/cyclopsian/wdisplays";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
