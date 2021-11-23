{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
, cairo, gdk-pixbuf, wayland, wayland-protocols
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "oguri-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "vilhalmer";
    repo = "oguri";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ cairo gdk-pixbuf wayland wayland-protocols ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A very nice animated wallpaper tool for Wayland compositors";
    homepage    = https://github.com/vilhalmer/oguri;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
