{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, ffmpeg
, libdrm
, wayland
}:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "wl-screenrec";
  version = metadata.rev;

  src = fetchFromGitHub {
    inherit (metadata) owner repo rev sha256;
  };

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
    libdrm
    wayland
  ];

  doCheck = false; # tries to use host compositor, etc

  meta = with lib; {
    description = "High performance wlroots screen recording, featuring hardware encoding";
    homepage = "https://github.com/russelltg/wl-screenrec";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "wl-screenrec";
    maintainers = with maintainers; [ colemickens ];
  };
}
