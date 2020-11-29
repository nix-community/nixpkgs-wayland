{ suffix, rev, sha256 }:

{ config, stdenv
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, fdk_aac
, ffmpeg
, jansson
, libjack2
, libxkbcommon
, libpthreadstubs
, libXdmcp
, qtbase
, qtx11extras
, qtwayland, wayland
, qtsvg
, speex
, libv4l
, x264
, curl
, xorg
, makeWrapper
, pkgconfig
, vlc
, mbedtls

, scriptingSupport ? true
, luajit
, swig
, python3

, alsaSupport ? stdenv.isLinux
, alsaLib
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio
}:

let
  inherit (stdenv.lib) optional optionals;
in mkDerivation rec {
  pname = "obs-studio-${suffix}";
  version = "unstable-wayland-latest";

  src = fetchFromGitHub {
    owner = "GeorgesStavracas";
    repo = "obs-studio";
    inherit rev sha256;
  };

  /*
  patches = (fetchpatch {
    url = "https://github.com/obsproject/obs-studio/pull/3182/commits/51c38080f2bced5a448f556188d0d1dec2551efc.patch";
    sha256 = "sha256-tpSYcLS5l0h4MmgAE9WayGbW2KBlbLsTDQi9dOf3T/U=";
  });
  */

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ curl
                  fdk_aac
                  ffmpeg
                  jansson
                  libjack2
                  libv4l
                  libxkbcommon
                  libpthreadstubs
                  libXdmcp
                  qtbase
                  qtx11extras
                  qtsvg
                  speex
                  x264
                  vlc
                  makeWrapper
                  mbedtls
                  qtwayland wayland
                ]
                ++ optionals scriptingSupport [ luajit swig python3 ]
                ++ optional alsaSupport alsaLib
                ++ optional pulseaudioSupport libpulseaudio;

  # obs attempts to dlopen libobs-opengl, it fails unless we make sure
  # DL_OPENGL is an explicit path. Not sure if there's a better way
  # to handle this.
  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-DDL_OPENGL=\\\"$(out)/lib/libobs-opengl.so\\\""
    "-DENABLE_WAYLAND=true"
    "-DENABLE_X11=false"
  ];

  postInstall = ''
      wrapProgram $out/bin/obs \
        --prefix "LD_LIBRARY_PATH" : "${xorg.libX11.out}/lib:${vlc}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = https://obsproject.com;
    maintainers = with maintainers; [ jb55 MP2E ];
    license = licenses.gpl2;
    platforms = [ "aarch64-linux" "x86_64-linux" "i686-linux" ];
  };
}
