{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk3
, gdk-pixbuf
, wrapGAppsHook
, librsvg
, withWayland ? false
, gtk-layer-shell
, stdenv
}:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = metadata.rev;

  src = fetchFromGitHub {
    inherit (metadata) owner repo rev sha256;
  };

  cargoLock = {
    lockFile = src + "/Cargo.lock";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 gdk-pixbuf librsvg ] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    (if withWayland then "wayland" else "x11")
  ];

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    broken = stdenv.isDarwin;
  };
}
