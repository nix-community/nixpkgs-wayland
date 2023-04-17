args_@{ attrName
  # the attr in nixpkgs could be different from what we want to provide
  # example: us libvncserver_master nixpkgs libvncserver
, nixpkgsAttrName
, prev
, extra
, replace
, replaceInput
, ...
}:

let
  inherit (prev) lib;
  metadata = import ../pkgs//${attrName}/metadata.nix;
  ignore = [ "attrName" "nixpkgsAttrName" "prev" "extra" "replace" "replaceInput" ];
  args = builtins.removeAttrs (args_ // replaceInput) ignore;
  nixpkgsAttr = if nixpkgsAttrName != "" then nixpkgsAttrName else attrName;
  overridenAttr = (lib.attrByPath (lib.splitString "." nixpkgsAttr) (throw "attr ${attrName} does not exist in nixpkgs") prev).override args;

  fetchers =
    let
      fetchSubmodules = metadata.fetchSubmodules or overridenAttr.src.fetchSubmodules or false;
    in
    {
      github = prev.fetchFromGitHub
        {
          inherit (metadata) owner repo rev sha256;
          inherit fetchSubmodules;
        };
      gitlab = prev.fetchFromGitLab
        {
          inherit (metadata) owner repo rev sha256;
          domain = metadata.domain or "gitlab.com";
          # uncomment after https://github.com/NixOS/nixpkgs/pull/198489
          #inherit fetchSubmodules;
        };
      gitea = prev.fetchFromGitea
        {
          inherit (metadata) owner repo rev sha256 domain;
          inherit fetchSubmodules;
        };
      gitsourcehut = prev.fetchFromSourcehut
        {
          inherit (metadata) owner repo rev sha256;
          inherit fetchSubmodules;
        };
      hgsourcehut = prev.fetchFromSourcehut {
        inherit (metadata) owner repo rev sha256;
        vc = "hg";
      };
    };

  src = fetchers.${metadata.type or "github"};


in
overridenAttr.overrideAttrs (oldAttrs: (
  {
    pname = attrName;
    version = "+${lib.substring 0 7 metadata.rev}";
    inherit src;
  } // lib.optionalAttrs (src ? meta.homepage) {
    meta = oldAttrs.meta // {
      homepage = src.meta.homepage;
    };
  } // lib.optionalAttrs (extra ? nativeBuildInputs)
    {
      nativeBuildInputs = extra.nativeBuildInputs ++ oldAttrs.nativeBuildInputs;
    } // lib.optionalAttrs (extra ? mesonFlags)
    {
      mesonFlags = extra.mesonFlags ++ oldAttrs.mesonFlags;
    } // lib.optionalAttrs (extra ? buildInputs)
    {
      buildInputs = extra.buildInputs ++ oldAttrs.buildInputs;
    } // replace
))
