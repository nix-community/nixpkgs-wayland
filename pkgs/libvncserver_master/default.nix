{ libvncserver, fetchFromGitHub }:

let metadata = import ./metadata.nix; in

libvncserver.overrideAttrs(old: {
  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "libvncserver";
    inherit (metadata) rev;
    inherit (metadata) sha256;
  };
})