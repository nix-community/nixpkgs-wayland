{ self, super, pkgs, fetchFromGitHub }:

let
  version = "c55d1542fe30ea7872a60a732fa88028cd4d4b06";
  sha256 = "0xfipgg2qh2xcf3a1pzx8pyh1aqpb9rijdyi0as4s6fhgy4w2666";
in
  super.wlroots.override {
    name = "wlroots-${version}";
    version = version;
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "wlroots";
      rev = version;
      sha256 = sha256;
    };
  }

