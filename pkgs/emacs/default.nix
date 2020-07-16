{ stdenv, fetchFromGitHub, emacs, cairo }:

let
  metadata = import ./metadata.nix;
in
(emacs.override { srcRepo = true; }).overrideAttrs (old: rec {
  name = "emacs-pgtk-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "masm11";
    repo = "emacs";
    rev = version;
    sha256 = metadata.sha256;
  };

  configureFlags = old.configureFlags ++ [ "--with-pgtk" "--with-cairo" ];

  buildInputs = old.buildInputs ++ [ cairo ];

  patches = [];
})
