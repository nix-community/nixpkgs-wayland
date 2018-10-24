{ self, super }:

let
in
  super.fmt.overrideAttrs (old: rec {
    patches = [ ./0001-add-fmt.pc.patch ];
  })
