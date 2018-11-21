{
  stdenv, fetchFromGitHub, rustPlatform
, libudev, pkgconfig
}:

let
  metadata = import ./metadata.nix;
  pname = "kanshi";
  version = metadata.rev;
in
rustPlatform.buildRustPackage {
  inherit pname version;
  name = "${pname}-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libudev ];

  cargoBuildFlags = [];

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = version;
    sha256 = metadata.sha256;
  };

  cargoSha256Version = 2;
  cargoSha256 = "0lf1zfmq9ypxk86ma0n4nczbklmjs631wdzfx4wd3cvhghyr8nkq";

  meta = with stdenv.lib; {
    description = "Dynamic display configuration";
    homepage = "https://github.com/emersion/kanshi";
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
    #license = licenses.unknown; # TODO: ???
  };
}
