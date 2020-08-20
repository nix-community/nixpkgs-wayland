# mostly used since nix-build-uncached needs it
# but also to fan out the packages into a list that only nix-build can build
let
  flake = (import (fetchTarball {
    url="https://github.com/edolstra/flake-compat/archive/c75e76f80c57784a6734356315b306140646ee84.tar.gz";
    sha256="071aal00zp2m9knnhddgr2wqzlx6i6qa1263lv1y7bdn2w20h10h";
  }) {
    src = builtins.fetchGit ./.;
  }).defaultNix;
in
  flake.packages."${builtins.currentSystem}"
