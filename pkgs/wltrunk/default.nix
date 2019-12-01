{ stdenv, fetchgit
, meson, ninja, pkgconfig
, wlroots, wayland, wayland-protocols
, pixman, libxkbcommon
, libudev, mesa_noglu, libX11
, libGL
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
  name = "wltrunk-${version}";
  version = metadata.rev;

  src = fetchgit {
    url = "https://git.sr.ht/~bl4ckb0ne/wltrunk";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    wlroots_ wayland wayland-protocols
    pixman libxkbcommon libudev mesa_noglu libX11
    libGL
  ];
  mesonFlags = [ "-Dauto_features=enabled" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "High-level Wayland compositor library based on wlroots";
    homepage    = "https://git.sr.ht/~bl4ckb0ne/wltrunk";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
