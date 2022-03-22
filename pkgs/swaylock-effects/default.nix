{ stdenv, lib, fetchFromGitHub
, meson, ninja
, pkg-config, scdoc
, wayland, wayland-protocols
, libxkbcommon, cairo, pango, gdk-pixbuf, pam
, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "swaylock-effects";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "mortie";
    repo = "swaylock-effects";
    rev = version;
    sha256 = metadata.sha256;
  };

  postPatch = ''
    sed -iE "0,/version: '.*',/ s//version: '${version}',/" meson.build
  '';

  nativeBuildInputs = [
    pkg-config meson ninja
  ] ++ lib.optional buildDocs scdoc;

  buildInputs = [
    wayland wayland-protocols
    libxkbcommon cairo pango gdk-pixbuf pam
  ];

  mesonFlags = [
    "-Dpam=enabled"
    "-Dgdk-pixbuf=enabled"
  ] ++ lib.optional buildDocs "-Dman-pages=enabled";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Swaylock, with fancy effects";
    homepage    = "https://github.com/mortie/swaylock-effects";
    license     = licenses.mit;
    platforms   = platforms.linux;
  };
}
