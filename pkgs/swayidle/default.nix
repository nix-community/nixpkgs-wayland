{ stdenv, lib, fetchFromGitHub
, meson, ninja
, pkgconfig, scdoc
, wayland, wayland-protocols
, systemd
, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "swayidle";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    rev = version;
    sha256 = metadata.sha256;
  };

  postPatch = ''
    sed -iE "0,/version: '.*',/ s//version: '${version}',/" meson.build
  '';

  nativeBuildInputs = [
    pkgconfig meson ninja
  ] ++ lib.optional buildDocs scdoc;

  buildInputs = [
    systemd
    wayland wayland-protocols
  ];

  mesonFlags = [
    "-Dlogind=enabled"
    "-Dlogind-provider=systemd"
  ] ++ lib.optional buildDocs "-Dman-pages=enabled";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Sway's idle management daemon";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
