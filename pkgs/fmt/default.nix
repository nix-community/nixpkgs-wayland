{ stdenv, fetchFromGitHub, cmake, enableShared ? true }:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  version = metadata.rev;
  name = "fmt-${version}";
  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };
  nativeBuildInputs = [ cmake ];
  doCheck = true;
  # preCheckHook ensures the test binaries can find libfmt.so.5
  preCheck = if enableShared
             then "export LD_LIBRARY_PATH=\"$PWD\""
             else "";
  cmakeFlags = [ "-DFMT_TEST=yes"
                 "-DBUILD_SHARED_LIBS=${if enableShared then "ON" else "OFF"}" ];
  meta = with stdenv.lib; {
    homepage = http://fmtlib.net/;
    description = "Small, safe and fast formatting library";
    longDescription = ''
      fmt (formerly cppformat) is an open-source formatting library. It can be
      used as a fast and safe alternative to printf and IOStreams.
    '';
    maintainers = [ maintainers.jdehaas ];
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
