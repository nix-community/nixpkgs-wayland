{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  libpulseaudio,
  alsa-lib,
  libxkbcommon,
  wayland,
  fontconfig,
}:

let
  metadata = import ./metadata.nix;
  libraryPath = lib.makeLibraryPath [
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "wldash";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "kennylevinsen";
    repo = "wldash";
    inherit (metadata) rev;
    inherit (metadata) sha256;
  };

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    libpulseaudio
    alsa-lib
    fontconfig
    libxkbcommon
  ];

  dontPatchELF = true;

  postInstall = ''
    patchelf --set-rpath ${libraryPath}:$(patchelf --print-rpath $out/bin/wldash) $out/bin/wldash
  '';

  meta = with lib; {
    description = "Wayland launcher/dashboard";
    homepage = "https://wldash.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ alexarice ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
