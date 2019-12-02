{ lib, rustPlatform, fetchFromGitHub, pkgconfig, dbus, libpulseaudio, alsaLib, libxkbcommon, wayland }:

let
  metadata = import ./metadata.nix;
  libraryPath = lib.makeLibraryPath [ wayland libxkbcommon ];
in
rustPlatform.buildRustPackage rec {
  name = "wldash-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "kennylevinsen";
    repo = "wldash";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  cargoSha256 = metadata.cargoSha256;

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus libpulseaudio alsaLib ];

  dontPatchELF = true;
  
  postInstall = ''
    patchelf --set-rpath ${libraryPath}:$(patchelf --print-rpath $out/bin/wldash) $out/bin/wldash
  '';

  meta = with lib; {
    description = "Wayland launcher/dashboard";
    homepage = "https://wldash.org";
    licence = licenses.gpl3;
    maintainers = with maintainers; [ alexarice ];
    platforms = platforms.linux;
  };
}
