{ lib
, stdenv
, fetchgit
, fcft
, libxkbcommon
, pkg-config
, pixman
, scdoc
, wayland
, wayland-protocols
, zig
}:

let md = import ./metadata.nix; in
stdenv.mkDerivation rec {
  pname = "wayprompt-unstable";
  version = "${md.rev}";

  src = fetchgit {
    url = md.repo_git;
    inherit (md) rev;
    inherit (md) sha256;
  };

  nativeBuildInputs = [
    zig
    pkg-config
    scdoc
    wayland
    # wayland-scanner
  ];
  buildInputs = [
    fcft
    libxkbcommon
    pixman
    wayland-protocols
  ];

  # Builds and installs (at the same time) with Zig.
  dontConfigure = true;
  # dontBuild = true;

  # Give Zig a directory for intermediate work.
  preInstall = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    ln -s "$out/bin/wayprompt" "$out/bin/hiprompt-wayprompt"
    ln -s "$out/bin/wayprompt" "$out/bin/pinentry-wayprompt"
    ln -s "$out/bin/wayprompt" "$out/bin/wayprompt-cli"
    runHook postInstall
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~leon_plickat/wayprompt";
    description = "multi-purpose prompt tool for Wayland";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
