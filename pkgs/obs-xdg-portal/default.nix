{ stdenv, fetchFromGitLab
, meson, ninja, pkgconfig
, obs-studio, gtk3, pipewire
, xdg-desktop-portal
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation {
  pname = "obs-xdg-portal";
  version = "unstable-${builtins.substring 0 8 metadata.rev}";

  src = fetchFromGitLab {
    owner = "feaneron";
    repo = "obs-xdg-portal";
    domain = "gitlab.gnome.org";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ obs-studio gtk3 pipewire xdg-desktop-portal ];

  PLUGIN_DIR = "${placeholder "out"}/share/obs/obs-plugins/obs-xdg-portal/bin/64bit";

  installPhase = ''
    mkdir -p $PLUGIN_DIR
    echo $PLUGIN_DIR
    cp obs-xdg-portal.so $PLUGIN_DIR
  '';

  meta = with stdenv.lib; {
    description = ''
      OBS Studio plugin using the Desktop portal for Wayland & X11 screencasting.
      This plugin only works with obs-studio-dmabuf.
    '';
    homepage = "https://gitlab.gnome.org/feaneron/obs-xdg-portal";
    maintainers = with maintainers; [ berbiche ];
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
}
