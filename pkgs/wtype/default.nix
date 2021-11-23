{ stdenv, lib, fetchFromGitHub
, pkg-config, meson, ninja
, wayland, wayland-protocols
, libxkbcommon
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "wtype-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "atx";
    repo = "wtype";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    wayland wayland-protocols
    libxkbcommon
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "xdotool type for wayland";
    homepage    = "https://github.com/atx/wtype";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
