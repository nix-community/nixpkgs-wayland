{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
, pango, libinput, libxkbcommon, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wshowkeys";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "ammgws";
    repo = "wshowkeys";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkg-config meson ninja ] ++ lib.optional buildDocs scdoc;
  buildInputs = [ pango wayland wayland-protocols libinput libxkbcommon ];
  mesonFlags = [
    "-Dauto_features=enabled"
  ] ++ lib.optional (!buildDocs) "-Dman-pages=disabled";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Displays keypresses on screen on supported Wayland compositors";
    homepage    = "https://github.com/ammgws/wshowkeys";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
