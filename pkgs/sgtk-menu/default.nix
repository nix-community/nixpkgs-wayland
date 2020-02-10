{ lib, fetchFromGitHub
, python3Packages
, gtk3
}:

let metadata = import ./metadata.nix; in
python3Packages.buildPythonApplication rec {
  pname = "sgtk-emnu";
  version = metadata.rev;
  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "sgtk-menu";
    inherit (metadata) rev sha256;
  };

  buildInputs = with python3Packages; [ setuptools gtk3 ];
  pythonPath = with python3Packages; [ pygobject3 pycairo gtk3  ];

  meta = with lib; {
    description = "GTK launcher for sway, i3 and some floating window managers";
    homepage = "https://github.com/nwg-piotr/sgtk-menu";
    maintainers = [ maintainers.colemickens ];
    license = licenses.gpl3;
  };
}
