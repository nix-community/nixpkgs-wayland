{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkgconfig
, libudev, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "kanshi";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja scdoc ];

  buildInputs = [
    wayland wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [ "-Dauto_features=disabled" ]
    ++ lib.optional (!buildDocs) "-Dman-pages=disabled";

  meta = with lib; {
    description = "Dynamic display configuration";
    homepage = "https://github.com/emersion/kanshi";
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
    #license = TODO;
  };
}
