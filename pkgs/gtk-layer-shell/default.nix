{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, libinput, gtk3, gobject-introspection
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "gtk-layer-shell";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk-layer-shell";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [
    wayland libinput gtk3 gobject-introspection
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library to create panels and other desktop components for Wayland using the Layer Shell protocol";
    homepage    = "https://github.com/wmww/gtk-layer-shell";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}

