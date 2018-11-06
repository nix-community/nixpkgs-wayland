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
  cargoSha256 = "098q1g04d5mpwlw1gshm78x28ki4gwhlkwqsd8vrfhp96v97n1sf";

  meta = with stdenv.lib; {
    description = "Dynamic display configuration";
    homepage = "https://github.com/emersion/kanshi";
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
    #license = licenses.unknown; # TODO: ???
  };
}
