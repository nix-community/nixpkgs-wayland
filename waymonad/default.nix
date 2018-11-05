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
  name = "waymonad-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "waymonad";
    repo = "waymonad";
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
    description = "A wayland compositor based on ideas from and inspired by xmonad";
    homepage    = "https://github.com/waymonad/waymonad";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
