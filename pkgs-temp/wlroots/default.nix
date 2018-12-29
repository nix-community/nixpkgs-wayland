{ stdenv, fetchFromGitHub, fetchpatch, meson, ninja, pkgconfig
, wayland, libGL, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa_noglu
, libpng, ffmpeg_4
, python3Packages # TODO: Temporary
}:

let
  pname = "wlroots";
  version = "36ba56140ae325ae398229a689f20ded126608bc";
  sha256 = "0wrc67g1vp3hk340hz1xn1xcy4rhmpd3dqb9ykxg69mpicrz3mvg";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "wlroots";
    rev = version;
    sha256 = sha256;
  };

  # $out for the library, $bin for rootston, and $examples for the example
  # programs (in examples) AND rootston
  outputs = [ "out" "bin" "examples" ];

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    wayland libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa_noglu
    libpng ffmpeg_4
  ];

  mesonFlags = [
    "-Dlibcap=enabled" "-Dlogind=enabled" "-Dxwayland=enabled" "-Dx11-backend=enabled"
    "-Dxcb-icccm=enabled" "-Dxcb-xkb=enabled" "-Dxcb-errors=enabled"
  ];

  postInstall = ''
    # Install rootston (the reference compositor) to $bin and $examples
    for output in "$bin" "$examples"; do
      mkdir -p $output/bin
      cp rootston/rootston $output/bin/
      mkdir $output/lib
      cp libwlroots* $output/lib/
      patchelf \
        --set-rpath "$output/lib:${stdenv.lib.makeLibraryPath buildInputs}" \
        $output/bin/rootston
      mkdir $output/etc
      cp ../rootston/rootston.ini.example $output/etc/rootston.ini
    done
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
       patchelf \
         --set-rpath "$examples/lib:${stdenv.lib.makeLibraryPath buildInputs}" \
         "$binary"
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  meta = with stdenv.lib; {
    description = "A modular Wayland compositor library";
    inherit (src.meta) homepage;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
