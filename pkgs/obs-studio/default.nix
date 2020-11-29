let
  metadata = import ./metadata.nix;
in
import ../obs-studio-base/base.nix {
  inherit (metadata) rev sha256;
  suffix = "egl";
}
