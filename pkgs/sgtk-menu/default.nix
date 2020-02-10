{ lib, fetchFromGitHub
, pythonPackages
#, pygobject3
}:

let metadata = import ./metadata.nix; in
pythonPackages.buildPythonApplication rec {
  pname = "sgtk-emnu";
  version = metadata.rev;
  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "sgtk-menu";
    inherit (metadata) rev sha256;
  };

  buildInputs = with pythonPackages; [ setuptools ];

  meta = with lib; {
    description = "GTK launcher for sway, i3 and some floating window managers";
    homepage = "https://github.com/nwg-piotr/sgtk-menu";
    maintainers = [ maintainers.colemickens ];
    license = licenses.gpl3;
  };
}
