{ gcc8Stdenv, lib, fetchFromGitHub
, pkg-config, cmake
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
    owner = "Osleg";
    repo = "gebaar-libinput-fork";
    rev = version;
    sha256 = metadata.sha256;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    libinput zlib #cpptoml
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput";
    homepage    = "https://github.com/Osleg/gebaar-libinput-fork";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
