{ stdenv, lib, fetchFromGitHub
, cmake, extra-cmake-modules, pkg-config
, wayland, wayland-protocols
, libepoxy, libpthreadstubs
, libGL, glfw3
, libX11, libXau, libXdmcp, libXrandr, libXext, libXinerama
, libXcursor, libXfixes
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wlay";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "atx";
    repo = "wlay";
    fetchSubmodules = true;
    rev = version;
    inherit (metadata) sha256;
  };

  nativeBuildInputs = [ pkg-config cmake extra-cmake-modules ];
  buildInputs = [
    wayland wayland-protocols
    libepoxy libpthreadstubs
    libGL glfw3
    libX11 libXau libXdmcp libXrandr libXext libXinerama
    libXcursor libXfixes
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Graphical output management for Wayland";
    homepage    = "https://github.com/atx/wlay";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
