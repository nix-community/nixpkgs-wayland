{ stdenv, fetchFromGitHub
, pkgconfig, cmake, extra-cmake-modules
, wayland, wayland-protocols
, libxkbcommon
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "wtype-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "atx";
    repo = "wtype";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig cmake extra-cmake-modules ];
  buildInputs = [
    wayland wayland-protocols
    libxkbcommon
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "xdotool type for wayland";
    homepage    = "https://github.com/atx/wtype";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
