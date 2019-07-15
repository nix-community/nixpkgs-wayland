{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols
, ffmpeg, x264, libpulseaudio
, scdoc
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wf-recorder";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    inherit (metadata) rev sha256;
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols ffmpeg x264 libpulseaudio ];

  meta = with stdenv.lib; {
    description = "Utility program for screen recording of wlroots-based compositors";
    homepage = https://github.com/ammen99/wf-recorder;
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms = platforms.linux;
  };
}
