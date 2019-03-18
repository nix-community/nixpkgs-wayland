{ gcc8Stdenv, fetchFromGitHub
, pkgconfig, cmake
, libinput, zlib
}:

let
  metadata = import ./metadata.nix;
in
gcc8Stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "gebaar-libinput";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "Coffee2CodeNL";
    repo = "gebaar-libinput";
    rev = version;
    sha256 = metadata.sha256;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    libinput zlib #cpptoml
  ];

  enableParallelBuilding = true;

  meta = with gcc8Stdenv.lib; {
    description = "Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput";
    homepage    = "https://github.com/Coffee2CodeNL/gebaar-libinput";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
