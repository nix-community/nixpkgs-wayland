{ stdenv, fetchFromGitHub, cmake, ninja, curl
}:

stdenv.mkDerivation rec {
  pname = "date";
  version = "unstable-2019-01-16";

  #src = /home/cole/code/date;
  src = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "c8d311f6f1b9ede6f66d510012da8002ef07a895";
    sha256 = "0gllvm374ljw9r833myi7pw9ym746jgqzqn8acv3pjd8f3js127z";
  };

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ curl ];

  postPatch = ''
    cp ${./date.pc.in} ./date.pc.in
    sed -i '32iconfigure_file(date.pc.in ''${CMAKE_INSTALL_LIBDIR}/pkgconfig/date.pc @ONLY)' \
      ./CMakeLists.txt
  '';

  cmakeFlags = [
    "-DBUILD_TZ_LIB=true"
    "-DBUILD_SHARED_LIBS=true"
  ];

  meta = with stdenv.lib; {
    homepage = "FIXME";
    description = "FIXME";
    #license = licenses.zlib;
    #platforms = platforms.all;
    platforms = platforms.linux;
  };
}
