{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, alsa-lib, ffmpeg, glib, openssl, pcre, zlib
, libX11, libXcursor, libXdamage, libXext, libXi, libXinerama, libXrandr, libXrender, libXv
, libxkbcommon, libxkbfile
, libusb1
, wayland
, gstreamer, gst-plugins-base, gst-plugins-good, libunwind, orc
, libpulseaudio ? null
, cups ? null
, pcsclite ? null
, systemd ? null
, buildServer ? true
, nocaps ? false
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "freerdp";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner  = "FreeRDP";
    repo   = "FreeRDP";
    rev    = version;
    inherit (metadata) sha256;
  };

  # outputs = [ "bin" "out" "dev" ];

  prePatch = ''
    export HOME=$TMP
    substituteInPlace "libfreerdp/freerdp.pc.in" \
      --replace "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"
  '' + lib.optionalString (pcsclite != null) ''
    substituteInPlace "winpr/libwinpr/smartcard/smartcard_pcsc.c" \
      --replace "libpcsclite.so" "${lib.getLib pcsclite}/lib/libpcsclite.so"
  '' + lib.optionalString nocaps ''
    substituteInPlace "libfreerdp/locale/keyboard_xkbfile.c" \
      --replace "RDP_SCANCODE_CAPSLOCK" "RDP_SCANCODE_LCONTROL"
  '';

  buildInputs = with lib; [
    alsa-lib cups ffmpeg glib openssl pcre pcsclite libpulseaudio zlib
    gstreamer gst-plugins-base gst-plugins-good libunwind orc
    libX11 libXcursor libXdamage libXext libXi libXinerama libXrandr libXrender libXv
    libxkbcommon libxkbfile
    wayland libusb1
  ] ++ optional stdenv.isLinux systemd;

  nativeBuildInputs = [
    cmake pkg-config
  ];

  enableParallelBuilding = true;

  doCheck = false;

  cmakeFlags = with lib; [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DWITH_CUNIT=OFF"
    "-DWITH_OSS=OFF"
  ] ++ optional (libpulseaudio != null)       "-DWITH_PULSE=ON"
    ++ optional (cups != null)                "-DWITH_CUPS=ON"
    ++ optional (pcsclite != null)            "-DWITH_PCSC=ON"
    ++ optional buildServer                   "-DWITH_SERVER=ON"
    ++ optional stdenv.isx86_64             "-DWITH_SSE2=ON";

  meta = with lib; {
    description = "A Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    homepage = "http://www.freerdp.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
