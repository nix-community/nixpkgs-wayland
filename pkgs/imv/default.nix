{ stdenv, fetchFromGitHub
, imv
}:

let metadata = import ./metadata.nix; in
imv.overrideAttrs(old: {
  pname = "imv-${metadata.rev}";
  version = metadata.rev;
  src = fetchFromGitHub {
    owner  = "eXeC64";
    repo   = "imv";
    rev    = metadata.rev;
    sha256 = metadata.sha256;
  };
})
