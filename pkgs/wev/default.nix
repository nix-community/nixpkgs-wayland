{ stdenv, lib, fetchgit
, pkg-config, scdoc
, wayland, wayland-protocols
, libxkbcommon
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "wev";
  version = metadata.rev;

  src = fetchgit {
    url = metadata.repo_git;
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkg-config scdoc ];
  buildInputs = [
    wayland wayland-protocols
    libxkbcommon
  ];

  installFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A tool for debugging events on a Wayland window, analagous to the X11 tool xev.";
    homepage    = "https://git.sr.ht/~sircmpwn/wev";
    #license     = licenses.unknown;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
