{ stdenv, fetchhg
, pkgconfig
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
    pkgconfig
  ];

  buildInputs = [
    wayland wayland-protocols
    gtk3 json_c libpulseaudio
  ];

  preConfigure = ''
    cd Release
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mv rootbar $out/bin/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Root Bar is a bar for wlroots based wayland compositors such as sway and was designed to address the lack of good bars for wayland";
    homepage    = "https://hg.sr.ht/~scoopta/rootbar";
    #license     = #TODO;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
