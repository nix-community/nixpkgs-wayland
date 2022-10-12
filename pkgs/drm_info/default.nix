{ stdenv
, lib
, fetchFromGitHub
, libdrm
, json_c
, meson
, ninja
, pkg-config
, libpciaccess
, scdoc
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "drm_info";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "ascent12";
    repo = "drm_info";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    libdrm
    json_c
    libpciaccess
    scdoc
  ];

  mesonFlags = [ "-Dlibpci=disabled" ];

  meta = with lib; {
    description = "Small utility to dump info about DRM devices.";
    homepage = "https://github.com/ascent12/drm_info";
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.linux;
  };
}
