{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  libxkbcommon,
  fontconfig,
}:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "salut";
  version = metadata.rev;

  src = fetchFromGitLab {
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

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxkbcommon
    fontconfig
  ];

  meta = with lib; {
    description = "A sleek notification daemon";
    homepage = "https://gitlab.com/snakedye/salut";
    license = licenses.mpl20;
  };
}
