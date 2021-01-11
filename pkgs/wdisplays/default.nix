{stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkgconfig
, gtk3, epoxy
, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wdisplays";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = "wdisplays";
    rev = version;
    sha256 = metadata.sha256;
  };

  patches = [
    # Fixes `Gdk-Message: 10:26:38.752: Error reading events from display: Success`
    # https://github.com/cyclopsian/wdisplays/pull/20
    (fetchpatch {
      name = "001_use_correct_versions_when_binding_globals.patch";
      url = "https://github.com/cyclopsian/wdisplays/commit/5198a9c94b40ff157c284df413be5402f1b75118.patch";
      sha256 = "1xwphyn0ksf8isy9dz3mfdhmsz4jv02870qz5615zs7aqqfcwn85";
    })
  ];

  nativeBuildInputs = [ pkgconfig meson ninja ] ++ stdenv.lib.optional buildDocs scdoc;
  buildInputs = [ gtk3 epoxy wayland wayland-protocols ];
  mesonFlags = [ "-Dauto_features=enabled" ]
    ++ stdenv.lib.optional (!buildDocs) "-Dman-pages=disabled";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GUI display configurator for wlroots compositors";
    homepage    = "https://github.com/cyclopsian/wdisplays";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
