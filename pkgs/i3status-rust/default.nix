{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, dbus, libpulseaudio }:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  name = "i3status-rust-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "greshake";
    repo = "i3status-rust";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };
  cargoPatches = [ ./0001-Cargo.lock-regenerate.patch ];

  cargoSha256 = "149070170ydjgdifv4fa1a1fh3mvpbgvwrlb3107dpdch2z7k9b9";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus libpulseaudio ];

  meta = with stdenv.lib; {
    description = "Very resource-friendly and feature-rich replacement for i3status";
    homepage = https://github.com/greshake/i3status-rust;
    license = licenses.gpl3;
    maintainers = [ maintainers.backuitist ];
    platforms = platforms.linux;
  };
}
