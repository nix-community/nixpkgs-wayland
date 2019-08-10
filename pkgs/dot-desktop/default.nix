{ lib, rustPlatform, fetchFromGitHub }:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  name = "dot-desktop-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "kennylevinsen";
    repo = "dot-desktop";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  cargoSha256 = "1q38pqasdbwb5r92srrm25lh786ib9bimx74rknwba9w1fk5p9r3";

  meta = with lib; {
    description = "Desktop file handler for application launchers";
    homepage = "https://github.com/kennylevinsen/dot-desktop";
    licenses = license.unfree;
    maintainers = with maintainers; [ alexarice ];
    platforms = platforms.all;
  };
}
