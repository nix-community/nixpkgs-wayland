{ self, super }:

let
  rev = "57ae5189351665715c98b3b6ca8595b30d83033f";
  sha256 = "1gy93mb1s1mq746kxj4c564k2mppqp5khqdfa6im88rv29cvrl4y";
in
  super.fmt.overrideAttrs (old: rec {
    patches = [
      (self.pkgs.fetchpatch {
        url = "https://github.com/fmtlib/fmt/pull/916/commits/${rev}.patch";
        sha256 = "${sha256}";
      })
    ];
  })

