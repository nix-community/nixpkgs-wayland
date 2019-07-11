{ stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  python3,
  makeWrapper,
  ncurses,
  expat,
  pkgconfig,
  freetype,
  fontconfig,
  libX11, libxcb,
  gzip,
  libXcursor,
  libXxf86vm,
  libXi,
  libXrandr,
  libGL,
  xclip,
  wayland,
  libxkbcommon,
  # Darwin Frameworks
  cf-private,
  AppKit,
  CoreFoundation,
  CoreGraphics,
  CoreServices,
  CoreText,
  Foundation,
  OpenGL }:

with rustPlatform;

let
  metadata = import ./metadata.nix;
  rpathLibs = [
    expat
    freetype
    fontconfig
    libX11
    libXcursor
    libXxf86vm
    libXrandr
    libGL
    libXi
    libxcb
  ] ++ lib.optionals stdenv.isLinux [
    wayland
    libxkbcommon
  ];
in buildRustPackage rec {
  pname = "alacritty";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = pname;
    rev = "${version}";
    sha256 = metadata.sha256;
  };

  cargoSha256 = "0l61ky19fjchiiirf7ayjk5fqc0r5025rxlik5ss7cl4r41jykw7";

  nativeBuildInputs = [
    cmake
    python3
    makeWrapper
    pkgconfig
    ncurses
    gzip
  ];

  buildInputs = rpathLibs
    ++ lib.optionals stdenv.isDarwin [
      AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL
      # Needed for CFURLResourceIsReachable symbols.
      cf-private
    ];

  outputs = [ "out" "terminfo" ];

#  postPatch = ''
#    substituteInPlace copypasta/src/x11.rs \
#      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
#  '';

  postBuild = lib.optionalString stdenv.isDarwin "make app";

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty

  '' + (if stdenv.isDarwin then ''
    mkdir $out/Applications
    cp -r target/release/osx/Alacritty.app $out/Applications/Alacritty.app
  '' else ''
    install -D extra/linux/alacritty.desktop -t $out/share/applications/
    install -D extra/logo/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  '') + ''

    install -D extra/completions/_alacritty -t "$out/share/zsh/site-functions/"
    install -D extra/completions/alacritty.bash -t "$out/etc/bash_completion.d/"
    install -D extra/completions/alacritty.fish -t "$out/share/fish/vendor_completions.d/"

    install -dm 755 "$out/share/man/man1"
    gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -x -o "$terminfo/share/terminfo" extra/alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    runHook postInstall
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "GPU-accelerated terminal emulator";
    homepage = https://github.com/jwilm/alacritty;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mic92 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
  };
}
