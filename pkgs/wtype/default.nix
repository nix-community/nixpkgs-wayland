{ stdenv, fetchFromGitHub
, pkgconfig, cmake, extra-cmake-modules
, wayland, wayland-protocols

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
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "High-level Wayland compositor library based on wlroots";
    homepage    = "https://git.sr.ht/~bl4ckb0ne/wltrunk";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
