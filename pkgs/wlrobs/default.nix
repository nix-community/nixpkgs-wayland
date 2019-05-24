# We don't have a wrapper which can supply obs-studio plugins so you have to
# somewhat manually install this:

# nix-env -f . -iA wlrobs
# mkdir -p ~/.config/obs-studio/plugins
# ln -s ~/.nix-profile/share/obs/obs-plugins/wlrobs ~/.config/obs-studio/plugins/

{ stdenv, fetchhg, obs-studio, cmake, wlroots, wayland
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
  nativeBuildInputs = [];
  buildInputs = [ obs-studio wayland wlroots ];
  buildPhase = ''
    cd Release
    make
  '';
  installPhase = ''
    mkdir -p $out/share/obs/obs-plugins/wlrobs/bin/64bit
    cp libwlrobs.so $out/share/obs/obs-plugins/wlrobs/bin/64bit
  '';

  meta = with stdenv.lib; {
    description = "wlrobs is an obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = "https://sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ colemickens ];
    platforms = with platforms; linux;
  };
}
