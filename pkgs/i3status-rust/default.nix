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

  cargoSha256 = "1cf3zf48ivxqjlal6m3jq3s5yc6lwkqjzjmfbxmw40c6ia77g9ry";

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
