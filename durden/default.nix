{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, wayland, wayland-protocols
, lbisdm, openal-soft, opengl, freetype
}:

let
  metadata = import ./metadata.nix;
  pname = "durden";
  version = metadata.rev;
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "durden";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    wayland libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa_noglu
    libpng ffmpeg_4
  ];

  mesonFlags = [
  ];

  meta = with stdenv.lib; {
    description = "Desktop Environment for Arcan ";
    homepage    = "https://durden.arcan-fe.com";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
