{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, systemd, wayland, wayland-protocols
, pipewire, libdrm, iniparser
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  name = "xdg-desktop-portal-wlr-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "xdg-desktop-portal-wlr";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ systemd wayland wayland-protocols pipewire libdrm iniparser];
  mesonFlags = [ "-Dauto_features=auto" ];

  # iniparser is missing a pkg-config...
  postPatch = ''
    substituteInPlace meson.build \
      --replace "cc.find_library('iniparser', dirs: [join_paths(get_option('prefix'),get_option('libdir'))])" "cc.find_library('iniparser', dirs: ['${iniparser}/lib'])"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "xdg-desktop-portal backend for wlroots";
    homepage    = "https://github.com/emersion/xdg-desktop-portal-wlr";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
