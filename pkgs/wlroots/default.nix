{ stdenv, lib, fetchFromGitHub, fetchpatch, meson, ninja, pkgconfig
, wayland, libGL, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa_noglu
, libglvnd
, libpng, ffmpeg_4
, libseat
, libuuid
, xorg # ?
, xwayland
}:

let
  metadata = import ./metadata.nix;
  pname = "wlroots";
  version = metadata.rev;
in stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "wlroots";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  # $out for the library, $bin for rootston, and $examples for the example
  # programs (in examples) AND rootston
  outputs = [ "out" "examples" ];

  nativeBuildInputs = [ meson ninja pkgconfig xwayland ];

  buildInputs = [
    wayland libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa_noglu
    libpng ffmpeg_4
    libglvnd
    libseat
    libuuid
    xorg.xcbutilrenderutil
  ];

  mesonFlags = [
    "-Dlibcap=enabled" "-Dxwayland=enabled" "-Dx11-backend=enabled"
    "-Dxcb-icccm=enabled" "-Dxcb-xkb=enabled" "-Dxcb-errors=enabled"
    "-Dlibseat=enabled"
  ];

  postInstall = ''
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  meta = with lib; {
    description = "A modular Wayland compositor library";
    inherit (src.meta) homepage;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
