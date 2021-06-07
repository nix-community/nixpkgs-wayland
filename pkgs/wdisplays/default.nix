{stdenv, lib, fetchFromGitHub, fetchpatch
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
    owner = "emersion";
    repo = "wdisplays";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ lib.optional buildDocs scdoc;
  buildInputs = [ gtk3 epoxy wayland wayland-protocols ];
  mesonFlags = [ "-Dauto_features=enabled" ]
    ++ lib.optional (!buildDocs) "-Dman-pages=disabled";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "GUI display configurator for wlroots compositors";
    homepage    = "https://github.com/cyclopsian/wdisplays";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
