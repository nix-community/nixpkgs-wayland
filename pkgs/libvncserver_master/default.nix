{ libvncserver, fetchFromGitHub }:

let metadata = import ./metadata.nix; in

libvncserver.overrideAttrs(old: {
  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "libvncserver";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };
})