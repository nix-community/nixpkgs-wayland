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
  pname = "swaylock";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
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
    description = "Screen locker for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
