{ stdenv, lib, fetchFromGitHub
, pkg-config, meson, ninja
, wayland, wayland-protocols
, libxkbcommon, libvncserver
, libpthreadstubs
, pixman, libuv, libglvnd
, neatvnc, libX11, libdrm
, aml, mesa, pam
, scdoc
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

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    wayland wayland-protocols
    libxkbcommon libvncserver
    libpthreadstubs
    pixman libuv libglvnd
    neatvnc libX11 libdrm
    aml mesa pam
    scdoc
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A VNC server for wlroots based Wayland compositors";
    homepage    = "https://github.com/any1/wayvnc";
    license     = licenses.isc;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
