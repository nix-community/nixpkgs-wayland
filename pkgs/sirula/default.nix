{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, glib
, cairo
, pango
, atk
, gdk-pixbuf
, gtk3
, gtk-layer-shell
}:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "sirula";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "DorianRudolph";
    repo = "sirula";
    rev = version;
    inherit (metadata) sha256;
  };

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib cairo pango atk gdk-pixbuf gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "Sirula (simple rust launcher) is an app launcher for wayland";
    homepage = "https://github.com/DorianRudolph/sirula";
    license = licenses.gpl3;
    #maintainers = with maintainers; [ jboyens ];
  };
}
