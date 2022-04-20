{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
, wayland, wayland-protocols
, ffmpeg, x264, libpulseaudio
, scdoc, opencl-headers, ocl-icd
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

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];
  buildInputs = [ wayland wayland-protocols ffmpeg x264 libpulseaudio opencl-headers ocl-icd ];

  meta = with lib; {
    description = "Utility program for screen recording of wlroots-based compositors";
    homepage = "https://github.com/ammen99/wf-recorder";
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms = platforms.linux;
  };
}
