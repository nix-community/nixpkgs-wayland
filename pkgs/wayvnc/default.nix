{ stdenv, fetchFromGitHub
, pkgconfig, meson, ninja
, wayland, wayland-protocols
, libxkbcommon, libvncserver
, libpthreadstubs
, pixman, libuv, libglvnd
, neatvnc, libX11, libdrm
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "wayvnc-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wayvnc";
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
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "";
    homepage    = "https://github.com/any1/wayvnc";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
