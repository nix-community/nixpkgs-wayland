{ stdenv
, fetchFromGitHub
, nixosTests
, substituteAll
, autoreconfHook
, pkgconfig
, libxml2
, glib
, pipewire
, fontconfig
, flatpak
, gsettings-desktop-schemas
, acl
, dbus
, fuse
, libportal
, geoclue2
, json-glib
, wrapGAppsHook
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal";
  version = metadata.rev;

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = metadata.sha256;
  };

  patches = [
    # Hardcode paths used by x-d-p itself.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit flatpak;
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    pipewire
    fontconfig
    flatpak
    acl
    dbus
    geoclue2
    fuse
    libportal
    gsettings-desktop-schemas
    json-glib
  ];

  # Seems to get stuck after "PASS: test-portals 39 /portal/inhibit/monitor"
  # TODO: investigate!
  doCheck = false;

  configureFlags = [
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/xdg-desktop-portal"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/xdg-desktop-portal"
  ];

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.xdg-desktop-portal;
    };
  };

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
