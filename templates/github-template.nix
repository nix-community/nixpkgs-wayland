args_@{ attrName
, prev
, extra
, ...
}:

let
  inherit (prev) lib;
  metadata = import ../pkgs//${attrName}/metadata.nix;
  ignore = [ "attrName" "prev" "extra" ];
  args = lib.filterAttrs (n: _: (!builtins.elem n ignore)) args_;
  overridenAttr = ((lib.attrByPath [ attrName ] (throw "attr ${attrName} does not exist in nixpkgs") prev).override args);
in
overridenAttr.overrideAttrs (old: (
  {
    version = metadata.rev;
    src = prev.fetchFromGitHub {
      inherit (metadata) owner repo rev sha256;
      fetchSubmodules = (builtins.hasAttr "fetchSubmodules" metadata && metadata.fetchSubmodules);
    };
  } // lib.optionalAttrs (extra ? nativeBuildInputs)
    {
      nativeBuildInputs = extra.nativeBuildInputs ++ old.nativeBuildInputs;
    } // lib.optionalAttrs (extra ? patches)
    {
      patches = extra.patches;
    }
)
)

