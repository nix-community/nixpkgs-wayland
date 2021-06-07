{ stdenv, lib, fetchhg
, meson, ninja, pkgconfig
, wayland, wayland-protocols
, gtk3, json_c, libpulseaudio
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "rootbar";
  version = metadata.rev;

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/rootbar";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
  ];

  buildInputs = [
    wayland wayland-protocols
    gtk3 json_c libpulseaudio
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Root Bar is a bar for wlroots based wayland compositors such as sway and was designed to address the lack of good bars for wayland";
    homepage    = "https://hg.sr.ht/~scoopta/rootbar";
    #license     = #TODO;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
