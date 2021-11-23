{stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
, gtk3, cairo, pango, systemd
, wayland, wayland-protocols
, scdoc, buildDocs ? true
, wrapGAppsHook
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "mako-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mako";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkg-config meson ninja wrapGAppsHook ] ++ lib.optional buildDocs scdoc;
  buildInputs = [ gtk3 cairo pango systemd wayland wayland-protocols ];
  mesonFlags = [
    "-Dauto_features=enabled"
    "-Dsystemd=disabled"
    "-Dsd-bus-provider=libsystemd"
  ] ++ lib.optional (!buildDocs) "-Dman-pages=disabled";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A lightweight Wayland notification daemon";
    homepage    = "https://wayland.emersion.fr/mako";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
