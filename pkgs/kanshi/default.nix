{ lib
, stdenv
, fetchgit
, meson
, ninja
, pkg-config
, scdoc
, wayland
, libvarlink
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "kanshi";
  version = metadata.rev;

  src = fetchgit {
    url = "https://git.sr.ht/~emersion/kanshi";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];
  buildInputs = [ wayland libvarlink ];

  meta = with lib; {
    homepage = "https://wayland.emersion.fr/kanshi";
    description = "Dynamic display configuration tool";
    longDescription = ''
      kanshi allows you to define output profiles that are automatically enabled
      and disabled on hotplug. For instance, this can be used to turn a laptop's
      internal screen off when docked.

      kanshi can be used on Wayland compositors supporting the
      wlr-output-management protocol.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ balsoft ];
    platforms = platforms.linux;
  };
}
