{ stdenv, fetchgit
, cmake, python3, pkgconfig
, libX11, libXxf86vm, libXrandr
, vulkan-headers, vulkan-loader, libglvnd
, wayland, wayland-protocols }:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "openxr-loader";
  version = metadata.rev;

  src = fetchgit {
    url = "https://github.com/emersion/OpenXR-SDK-Source";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ cmake python3 pkgconfig ];
  buildInputs = [
    libX11 libXxf86vm libXrandr
    vulkan-headers vulkan-loader libglvnd
    wayland wayland-protocols
  ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DPRESENTATION_BACKEND=wayland"
    "-DBUILD_LOADER=ON"
    "-DBUILD_ALL_EXTENSIONS=ON"
    "-DBUILD_API_LAYERS=ON"
    "-DOpenGL_GL_PREFERENCE=GLVND"
    #"-DXR_USE_GRAPHICS_API_OPENGL_ES"
	  #"-DXR_USE_PLATFORM_EGL"
  ];

  outputs = [ "out" "dev" "layers" ];

  postInstall = ''
    mkdir -p "$layers/share"
    mv "$out/share/openxr" "$layers/share"
    # Use absolute paths in manifests so no LD_LIBRARY_PATH shenanigans are necessary
    for file in "$layers/share/openxr/1/api_layers/explicit.d/"*; do
        substituteInPlace "$file" --replace '"library_path": "lib' "\"library_path\": \"$layers/lib/lib"
    done
    mkdir -p "$layers/lib"
    mv "$out/lib/libXrApiLayer"* "$layers/lib"
  '';

  meta = with stdenv.lib; {
    description = "(sircmpwn fork) Khronos OpenXR loader";
    homepage    = "https://git.sr.ht/~sircmpwn/OpenXR-SDK-Source";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [];
  };
}
