{ stdenv, fetchgit
, meson, ninja, pkgconfig, scdoc
, wlroots, wayland, wayland-protocols
, pixman, libxkbcommon
, libudev, mesa_noglu, libX11 # not mentioned in meson.build...
, wltrunk, libGL
}:

let
  metadata = import ./metadata.nix;
  wlroots_ = wlroots.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace "backend/rdp/peer.c" \
       --replace \
         "nsc_context_set_pixel_format(context->nsc_context, PIXEL_FORMAT_BGRA32);" \
         "return nsc_context_set_parameters(context->nsc_context, NSC_COLOR_FORMAT, PIXEL_FORMAT_BGRA32);"
    '';
  });
in
stdenv.mkDerivation rec {
  name = "bspwc-${version}";
  version = metadata.rev;

  src = fetchgit {
    url = "https://git.sr.ht/~bl4ckb0ne/bspwc";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja scdoc ];
  buildInputs = [
    wayland wayland-protocols wlroots_ wltrunk
    pixman libxkbcommon libudev mesa_noglu libX11 libGL
  ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Binary space partitioning wayland compositor";
    homepage    = "https://git.sr.ht/~bl4ckb0ne/bspwc";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
