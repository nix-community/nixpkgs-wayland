{ stdenv, lib, fetchFromGitHub
, cmake, extra-cmake-modules, pkgconfig
, wayland, wayland-protocols
, epoxy, libpthreadstubs
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
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig cmake extra-cmake-modules ];
  buildInputs = [
    wayland wayland-protocols
    epoxy libpthreadstubs
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
