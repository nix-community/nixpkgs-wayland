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
  cargoSha256 = "0pvkrdjrg9y38vsrqkrvsknzp78sknpmq14rskvij450a9mpihii";

  meta = with stdenv.lib; {
    description = "Dynamic display configuration";
    homepage = "https://github.com/emersion/kanshi";
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
    #license = licenses.unknown; # TODO: ???
  };
}
