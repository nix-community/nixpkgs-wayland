{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "wl-clipboard-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "bugaevc";
    repo = "wl-clipboard";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ wayland wayland-protocols ];
  mesonFlags = [ "-Dfishcompletiondir=no"];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Select a region in a Wayland compositor";
    homepage    = https://github.com/bugaevc/wl-clipboard;
    #license     = licenses.mit; # TODO none listed
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
