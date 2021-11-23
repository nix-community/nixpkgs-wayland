{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
, wayland, wayland-protocols
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wlr-randr";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    inherit (metadata) rev sha256;
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    wayland wayland-protocols
  ];

  meta = with lib; {
    description = "An xrandr clone for wlroots compositors";
    homepage = "https://github.com/emersion/wlr-randr";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
  };
}
