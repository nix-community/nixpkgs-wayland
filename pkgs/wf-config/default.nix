{ stdenv, fetchFromGitHub
, pkgconfig, meson, ninja
, libevdev, wlroots, glm, libxml2
, buildDocs ? true
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "wf-config";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-config";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ libevdev wlroots glm libxml2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for managing configuration files, written for wayfire";
    homepage    = "https://github.com/WayfireWM/wf-config";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
