{ stdenv, lib, fetchFromGitHub, makeWrapper
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf
, wlroots, wayland-protocols
, fetchpatch
}:

let metadata = import ./metadata.nix; in
stdenv.mkDerivation rec {
  pname = "sway-unwrapped";
  version = "${metadata.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  patches = [
    ./sway-config-no-nix-store-references.patch
    ./load-configuration-from-etc.patch
    (fetchpatch {
      url = "https://github.com/swaywm/sway/pull/5090.patch";
      sha256 = "11zsjzsg2lnbq9nzr7q9bm1x98rcijbc9dbknd7zbpwbrg8hdw23";
    })
  ];

  postPatch = ''
    # replace the version
    date="$(date -d '${metadata.revdate}' +'%b %d %Y')"
    sed -i "s/\([ \t]\)version: '\(.*\)',/\1version: '\2-${lib.substring 0 8 metadata.rev} ($date, branch \\\'${metadata.branch}\\\')',/" meson.build
  '';

  nativeBuildInputs = [
    pkgconfig meson ninja scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk-pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Ddefault-wallpaper=false" "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled"
    "-Dtray=enabled" "-Dman-pages=enabled"
  ];

  meta = with stdenv.lib; {
    description = "i3-compatible tiling Wayland compositor";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
