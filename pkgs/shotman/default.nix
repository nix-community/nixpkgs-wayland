{ stdenv
, lib
, fetchgit
, rustPlatform
, pkg-config
, libxkbcommon
}:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "shotman";
  version = metadata.rev;

  src = fetchgit {
    url = metadata.repo_git;
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  cargoSha256 = metadata.cargoSha256;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxkbcommon
  ];

  meta = with lib; {
    description = "Uncompromising screenshot GUI for Wayland";
    homepage = "https://git.sr.ht/~whynothugo/shotman";
  };
}
