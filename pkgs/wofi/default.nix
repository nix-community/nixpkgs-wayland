{ stdenv, fetchhg
, pkgconfig
, wayland, wayland-protocols
, gtk3
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "wofi";
  version = metadata.rev;

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wofi";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    wayland wayland-protocols
    gtk3
  ];

  preConfigure = ''
    cd Release
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mv wofi $out/bin/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Wofi is a launcher/menu program for wlroots based wayland compositors such as sway";
    homepage    = "https://hg.sr.ht/~scoopta/wofi";
    #license     = #TODO;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
