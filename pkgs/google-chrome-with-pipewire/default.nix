{ stdenv, symlinkJoin, makeWrapper
, google-chrome
, channel ? "stable"
, pipewire
}:

stdenv.mkDerivation {
  name = "google-chrome-with-pipewire-${google-chrome.version}";
  buildInputs = [ makeWrapper ];
  buildCommand = ''
    case ${channel} in
      beta) appname=chrome-beta      dist=beta     ;;
      dev)  appname=chrome-unstable  dist=unstable ;;
      *)    appname=chrome           dist=stable   ;;
    esac

    makeWrapper \
      "$(readlink -v --canonicalize-existing "${google-chrome}/bin/google-chrome-$dist")" \
      $out/bin/google-chrome-$dist \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ pipewire ]}
  '';
}
