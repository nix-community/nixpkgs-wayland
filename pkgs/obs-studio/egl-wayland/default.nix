let
  metadata = import ./metadata.nix;
in
import ../base.nix {
  inherit (metadata) rev sha256;
}
