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
  name = "waybox-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "wizbright";
    repo = "waybox";
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
    description = "Wayland compositor based on BSPWM";
    homepage    = "https://github.com/Bl4ckb0ne/bspwc";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
