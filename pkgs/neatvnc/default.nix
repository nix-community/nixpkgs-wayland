{ stdenv, lib, fetchFromGitHub
, pkg-config, meson, ninja
, wayland, wayland-protocols
, libxkbcommon, libvncserver
, ffmpeg
, libpthreadstubs, libdrm
, pixman, libuv, libglvnd
, gnutls, mesa
, aml, libjpeg_turbo
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "neatvnc-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "any1";
    repo = "neatvnc";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    wayland wayland-protocols
    libxkbcommon libvncserver
    ffmpeg
    libpthreadstubs libdrm
    pixman libuv libglvnd
    gnutls mesa
    aml libjpeg_turbo
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
