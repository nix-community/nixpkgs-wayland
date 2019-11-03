{ stdenv, fetchgit
, pkgconfig, scdoc
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

  installFlags = [
    "PREFIX=$(out)"
  ];

  nativeBuildInputs = [ pkgconfig scdoc ];
  buildInputs = [
    wayland wayland-protocols
    libxkbcommon
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Sway's idle management daemon";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
