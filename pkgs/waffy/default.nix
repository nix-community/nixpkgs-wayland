{ stdenv, fetchFromGitHub
, cmake
, wayland, wayland-protocols, gtk-layer-shell
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "waffy";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "wvffle";
    repo = "waffy";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    wayland wayland-protocols
    gtk-layer-shell
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "wlroots compatible, touch friendly application launcher";
    homepage    = "https://github.com/wvffle/waffy";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}

