{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols
, gtk3, wlroots
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wl-gammactl";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "mischw";
    repo = pname;
    inherit (metadata) rev sha256;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    gtk3 wlroots
    wayland wayland-protocols
  ];

  preConfigure = ''
    sed -i 32,46d ./meson.build
  '';

  meta = with stdenv.lib; {
    description = "Small GTK GUI application to set contrast, brightness and gamma for wayland compositors which support the wlr-gamma-control protocol extension.";
    homepage = "https://github.com/mischw/wl-gammactl";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
  };
}
