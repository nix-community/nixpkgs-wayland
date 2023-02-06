{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
}:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = metadata.rev;

  src = fetchFromGitHub {
    inherit (metadata) owner repo rev sha256;
  };

  inherit (metadata) cargoSha256;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
  ];

  # FIXME: The tests rely on a running wayland environment
  #        providing a socket. Not sure how to address this
  doCheck = false;

  meta = with lib; {
    description = "A Solution to your Wayland Wallpaper Woes";
    homepage = "https://github.com/Horus645/swww";
    license = licenses.gpl3;
  };
}
