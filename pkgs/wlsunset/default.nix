{ stdenv, lib, fetchgit
, meson, ninja, pkg-config
, cairo, libjpeg, wayland, wayland-protocols
, scdoc, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wlsunset";
  version = metadata.rev;

  src = fetchgit {
    url = metadata.repo_git;
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkg-config meson ninja ] ++ lib.optional buildDocs scdoc;
  buildInputs = [ cairo libjpeg wayland wayland-protocols ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Day/night gamma adjustments for Wayland";
    homepage    = "https://git.sr.ht/~kennylevinsen/wlsunset";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
