{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, libpulseaudio
, alsa-lib
, libxkbcommon
, wayland
, fontconfig
}:

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
    inherit (metadata) rev;
    inherit (metadata) sha256;
  };

  inherit (metadata) cargoSha256;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus libpulseaudio alsa-lib fontconfig ];

  dontPatchELF = true;

  postInstall = ''
    patchelf --set-rpath ${libraryPath}:$(patchelf --print-rpath $out/bin/wldash) $out/bin/wldash
  '';

  meta = with lib; {
    description = "Wayland launcher/dashboard";
    homepage = "https://wldash.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ alexarice ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
