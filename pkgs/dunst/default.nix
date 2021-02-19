{ fetchFromGitHub
, dunst
, wayland, wayland-protocols
}:

let metadata = import ./metadata.nix; in

dunst.overrideAttrs(old: {
  pname = "dunst-${metadata.rev}";
  version = metadata.rev;
  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  installFlags = [ "SYSCONFDIR=${placeholder "out"}/etc" ];

  buildInputs = old.buildInputs ++ [ wayland wayland-protocols ];
})
