{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, wayland, wayland-protocols
, openalSoft, freetype
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

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    wayland wayland-protocols
    openalSoft freetype
  ];

  preConfig = ''
    cd source/src
  '';

  meta = with stdenv.lib; {
    description = "Arcan - [Display Server, Multimedia Framework, Game Engine] -> \"Desktop Engine\" modular Wayland compositor library";
    homepage    = "https://arcan-fe.com";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
