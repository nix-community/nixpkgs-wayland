{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "wl-gammarelay-rs";
  version = metadata.rev;

  src = fetchFromGitHub {
    inherit (metadata)
      owner
      repo
      rev
      sha256
    ;
  };

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  meta = with lib; {
    description = "A simple program that provides DBus interface to control display temperature and brightness under wayland without flickering ";
    homepage = "https://github.com/MaxVerevkin/wl-gammarelay-rs";
    license = licenses.gpl3;
    maintainers = with maintainers; [ artturin ];
  };
}
