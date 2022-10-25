args_@{ attrName
, prev
, ...
}:

let
  inherit (prev) lib;
  metadata = import ../pkgs//${attrName}/metadata.nix;
  ignore = [ "attrName" "prev" ];
  args = lib.filterAttrs (n: _: (!builtins.elem n ignore)) args_;
  overridenAttr = ((lib.attrByPath [ attrName ] (throw "attr ${attrName} does not exist in nixpkgs") prev).override args);
in
overridenAttr.overrideAttrs (_: {
  version = metadata.rev;
  src = prev.fetchFromGitHub {
    inherit (metadata) owner repo rev sha256;
  };
})

