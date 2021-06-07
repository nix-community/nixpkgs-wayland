{ stdenv, lib, fetchFromGitHub
, pkgconfig, meson, ninja
, wayland, wayland-protocols
, libxkbcommon, libvncserver
, libpthreadstubs, libdrm
, pixman, libuv, libglvnd
, gnutls
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "aml-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "any1";
    repo = "aml";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    wayland wayland-protocols
    libxkbcommon libvncserver
    libpthreadstubs libdrm
    pixman libuv libglvnd
    gnutls
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "liberally licensed VNC server library that's intended to be fast and neat";
    homepage    = "https://github.com/any1/neatvnc";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
