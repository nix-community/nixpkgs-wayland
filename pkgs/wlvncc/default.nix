{ stdenv, fetchFromGitHub
, pkgconfig, meson, ninja
, wayland, wayland-protocols
, libxkbcommon, libvncserver
, libpthreadstubs
, pixman, libuv, libglvnd
, neatvnc, libX11, libdrm
, aml, mesa
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wlvncc";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wlvncc";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    wayland wayland-protocols
    libxkbcommon libvncserver
    libpthreadstubs
    pixman libuv libglvnd
    neatvnc libX11 libdrm
    aml mesa
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Wayland Native VNC Client";
    homepage    = "https://github.com/any1/wlvncc";
    license     = licenses.isc;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
