{ lib, stdenv, fetchFromGitHub, makeWrapper
, meson, ninja, pkg-config, wayland-protocols
, pipewire, wayland, systemd, libdrm, iniparser, inih, scdoc, grim, slurp }:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-wlr";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "xdg-desktop-portal-wlr";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols makeWrapper ];
  buildInputs = [ pipewire wayland systemd libdrm iniparser scdoc inih ];

  mesonFlags = [
    "-Dsd-bus-provider=libsystemd"
  ];

  postInstall = ''
    wrapProgram $out/libexec/xdg-desktop-portal-wlr --prefix PATH ":" ${lib.makeBinPath [ grim slurp ]}
  '';

  meta = with lib; {
    description = "xdg-desktop-portal backend for wlroots";
    homepage    = "https://github.com/emersion/xdg-desktop-portal-wlr";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
