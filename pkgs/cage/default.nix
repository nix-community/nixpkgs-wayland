{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland-scanner, scdoc, makeWrapper
, wlroots, wayland, wayland-protocols, pixman, libxkbcommon
, systemd, libGL, libX11, mesa
, xwayland ? null
, nixosTests
}:

let metadata = import ./metadata.nix; in
stdenv.mkDerivation rec {
  pname = "cage";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = "cage";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner scdoc makeWrapper ];

  buildInputs = [
    wlroots wayland wayland-protocols pixman libxkbcommon
    mesa # for libEGL headers
    systemd libGL libX11
  ];

  mesonFlags = [ "-Dxwayland=${lib.boolToString (xwayland != null)}" ];

  postFixup = lib.optionalString (xwayland != null) ''
    wrapProgram $out/bin/cage --prefix PATH : "${xwayland}/bin"
  '';

  # Tests Cage using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.cage;

  meta = with lib; {
    description = "A Wayland kiosk that runs a single, maximized application";
    homepage    = "https://www.hjdskes.nl/projects/cage/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
