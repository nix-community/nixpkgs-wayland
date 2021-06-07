# We don't have a wrapper which can supply obs-studio plugins so you have to
# somewhat manually install this:

# nix-env -f . -iA wlrobs
# mkdir -p ~/.config/obs-studio/plugins
# ln -s ~/.nix-profile/share/obs/obs-plugins/wlrobs ~/.config/obs-studio/plugins/

{ stdenv, lib, fetchhg
, meson, ninja, pkg-config
, obs-studio, wlroots, wayland
, libX11, libGL, libdrm
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "wlrobs-${version}";
  version = metadata.rev;
  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wlrobs";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };
  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ obs-studio wayland wlroots libX11 libGL libdrm ];

  installPhase = ''
    mkdir -p $out/share/obs/obs-plugins/wlrobs/bin/64bit
    cp libwlrobs.so $out/share/obs/obs-plugins/wlrobs/bin/64bit
  '';

  meta = with lib; {
    description = "wlrobs is an obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = "https://sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ colemickens ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    #platforms = with platforms; linux;
  };
}
