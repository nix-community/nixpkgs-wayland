{ lib, rustPlatform, fetchFromGitHub, pkgconfig, dbus, libpulseaudio, libxkbcommon, wayland }:

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

  cargoSha256 = "11068w763pv2f1a7zcpdwb7s9skvvknxxngnmz71haiw07h5jjiz";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus libpulseaudio ];

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
