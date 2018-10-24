{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols, sway, wlroots
, libpulseaudio, libinput, libnl, gtkmm3
, fmt, jsoncpp
, git
, python3Packages # TODO: temporary (meson480)
}:

let
  metadata = import ./metadata.nix;
  meson480 = meson.overrideAttrs (oldAttrs: rec {
    name = pname + "-" + version;
    pname = "meson";
    version = "0.48.0";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0qawsm6px1vca3babnqwn0hmkzsxy4w0gi345apd2qk3v0cv7ipc";
    };
    patches = builtins.filter # Remove gir-fallback-path.patch
      (str: !(stdenv.lib.hasSuffix "gir-fallback-path.patch" str))
      oldAttrs.patches;
  });
in
stdenv.mkDerivation rec {
  name = "waybar-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = version;
    sha256 = metadata.sha256;
  };

  patches = [
    ./00001-waybar-gcc7.patch
    ./00002-waybar-outprefix.patch
    #./00003-waybar-meson.patch
  ];

  nativeBuildInputs = [ meson480 ninja pkgconfig ];
  buildInputs = [
    wayland wayland-protocols sway wlroots
    libpulseaudio libinput libnl gtkmm3
    git fmt jsoncpp
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
    "-Doutprefix=$out"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors.";
    homepage    = https://github.com/Alexays/Waybar;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}

