{ lib, fetchFromGitHub, buildGoModule }:

let metadata = import ./metadata.nix; in
buildGoModule rec {
  pname = "clipman";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "yory8";
    repo = "clipman";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  modSha256 = metadata.modSha256;

  meta = with lib; {
    description = "A basic clipboard manager for Wayland, with support for persisting copy buffers after an application exits";
    homepage = "https://github.com/yory8/clipman";
    license = licenses.gpl3;
    maintainers = with maintainers; [ colemickens ];
  };
}
