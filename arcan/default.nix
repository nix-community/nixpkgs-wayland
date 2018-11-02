{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, wayland, wayland-protocols
, lbisdm, openal-soft, opengl, freetype
}:

let
  metadata = import ./metadata.nix;
  pname = "arcan";
  version = metadata.rev;
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "arcan";
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
    description = "Arcan - [Display Server, Multimedia Framework, Game Engine] -> \"Desktop Engine\" modular Wayland compositor library";
    homepage    = "https://arcan-fe.com";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
