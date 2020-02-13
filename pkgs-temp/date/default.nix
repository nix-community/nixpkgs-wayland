{ stdenv, fetchFromGitHub, fetchpatch
, cmake, ninja, curl }:

stdenv.mkDerivation rec {
  pname = "date";
  version = "unstable-2019-01-16";

  src = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "9a0ee2542848ab8625984fc8cdbfb9b5414c0082";
    sha256 = "0yxsn0hj22n61bjywysxqgfv7hj5xvsl6isma95fl8xrimpny083";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/HowardHinnant/date/pull/538.patch";
      sha256 = "0m3qbhq7kmm9qa3jm6d2px7c1dxdj5k9lffgdvqnrwmhxwj1p9n2";
    })
  ];

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ curl ];

  cmakeFlags = [
    "-DBUILD_TZ_LIB=true"
    "-DBUILD_SHARED_LIBS=true"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/HowardHinnant/date";
    description = "A date and time library based on the C++11/14/17 <chrono> header";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

