{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wlroots, wayland, wayland-protocols
, pixman, libxkbcommon
, libudev, mesa_noglu, libX11 # not mentioned in meson.build...
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "trinkster-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "Dreyri";
    repo = "trinkster";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    wlroots wayland wayland-protocols wlroots
    pixman libxkbcommon libudev mesa_noglu libX11
  ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Experimental wayland compositor";
    homepage    = "https://github.com/Dreyri/trinkster";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
