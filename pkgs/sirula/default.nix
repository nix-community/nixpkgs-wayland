{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, glib, cairo, pango, atk
, gdk-pixbuf, gtk3, gtk-layer-shell }:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  name = "sirula-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "DorianRudolph";
    repo = "sirula";
    rev = version;
    sha256 = metadata.sha256;
  };

  cargoSha256 = metadata.cargoSha256;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib cairo pango atk gdk-pixbuf gtk3 gtk-layer-shell ];

  meta = with stdenv.lib; {
    description = "Sirula (simple rust launcher) is an app launcher for wayland";
    homepage = "https://github.com/DorianRudolph/sirula";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jboyens ];
  };
}
