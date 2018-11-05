{ stdenv, lib, fetchFromGitHub, rustPlatform, cmake, pkgconfig
, gtk3, qt5, ncurses
, python3, openssl, libgpgerror, gpgme
}:

with rustPlatform;

let
  metadata = import ./metadata.nix;
in buildRustPackage rec {
  name = "ripasso-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };
  patches = [ ./0001-add-Cargo.lock.patch ];

  cargoSha256 = "0ax8k7y6azahrz3zr06042n1dvhisvx0d3r2xhlv32j3q5fjbvbc";

  nativeBuildInputs = [ cmake pkgconfig ];
  cargoBuildFlags = [ "--all" ];

  buildInputs = [
    gtk3 ncurses
    qt5.qtbase qt5.qtsvg qt5.qtdeclarative
    python3 openssl libgpgerror gpgme
  ];

  meta = with stdenv.lib; {
    description = "A simple password manager written in Rust";
    homepage = "https://github.com/cortex/ripasso";
    maintainers = maintainers.colemickens;
    platforms = platforms.linux;
    #license = with licenses; [ asl20 ]; # unlisted # TODO file issue
  };
}
