{ stdenv, lib, fetchgit
, imv
}:

let metadata = import ./metadata.nix; in
imv.overrideAttrs(old: {
  pname = "imv-${metadata.rev}";
  version = metadata.rev;
  src = fetchgit {
    url    = metadata.repo_git;
    rev    = metadata.rev;
    sha256 = metadata.sha256;
  };
})
