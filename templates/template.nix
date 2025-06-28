args_@{
  attrName,
  # the attr in nixpkgs could be different from what we want to provide
  # example: us libvncserver_master nixpkgs libvncserver
  nixpkgsAttrName,
  prev,
  extra,
  replace,
  replaceInput,
  deprecationWarning,
  ...
}:

let
  inherit (prev) lib;
  metadata = import ../pkgs/${attrName}/metadata.nix;
  ignore = [
    "attrName"
    "nixpkgsAttrName"
    "prev"
    "extra"
    "replace"
    "replaceInput"
    "deprecationWarning"
  ];
  args = builtins.removeAttrs (args_ // replaceInput) ignore;
  nixpkgsAttr = if nixpkgsAttrName != "" then nixpkgsAttrName else attrName;
  overridenAttr =
    (lib.attrByPath (lib.splitString "." nixpkgsAttr)
      (throw "attr ${attrName} does not exist in nixpkgs")
      prev
    ).override
      args;
  overridenAttr' = lib.warnIf (
    deprecationWarning != ""
  ) "nixpkgs-wayland: ${deprecationWarning}" overridenAttr;

  fetchers =
    let
      fetchSubmodules = metadata.fetchSubmodules or overridenAttr.src.fetchSubmodules or false;
    in
    {
      github = prev.fetchFromGitHub {
        inherit (metadata)
          owner
          repo
          rev
          sha256
          ;
        inherit fetchSubmodules;
      };
      gitlab = prev.fetchFromGitLab {
        inherit (metadata)
          owner
          repo
          rev
          sha256
          ;
        domain = metadata.domain or "gitlab.com";
        # uncomment after https://github.com/NixOS/nixpkgs/pull/198489
        #inherit fetchSubmodules;
      };
      gitea = prev.fetchFromGitea {
        inherit (metadata)
          owner
          repo
          rev
          sha256
          domain
          ;
        inherit fetchSubmodules;
      };
      gitsourcehut = prev.fetchFromSourcehut {
        inherit (metadata)
          owner
          repo
          rev
          sha256
          ;
        inherit fetchSubmodules;
      };
      hgsourcehut = prev.fetchFromSourcehut {
        inherit (metadata)
          owner
          repo
          rev
          sha256
          ;
        vc = "hg";
      };
    };

  src = fetchers.${metadata.type or "github"};

  cargoLock = {
    lockFile = src + "/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  replace' = previousAttrs: if builtins.isFunction replace then replace previousAttrs else replace;
in
overridenAttr'.overrideAttrs (
  previousAttrs:
  (
    {
      pname = attrName;
      version = "+${lib.substring 0 7 metadata.rev}";
      inherit src;
      # `--version` will be different than the version above
      dontVersionCheck = true;
    }
    // lib.optionalAttrs (src ? meta.homepage) {
      meta = previousAttrs.meta // {
        inherit (src.meta) homepage;
        # null changelog as it may use `finalAttrs.src.tag` while we use `rev`
        changelog = null;
      };
    }
    // lib.optionalAttrs (extra ? depsBuildBuild) {
      depsBuildBuild = extra.depsBuildBuild ++ previousAttrs.depsBuildBuild;
    }
    // lib.optionalAttrs (extra ? nativeBuildInputs) {
      nativeBuildInputs = extra.nativeBuildInputs ++ previousAttrs.nativeBuildInputs;
    }
    // lib.optionalAttrs (extra ? mesonFlags) {
      mesonFlags = previousAttrs.mesonFlags ++ extra.mesonFlags;
    }
    // lib.optionalAttrs (extra ? buildInputs) {
      buildInputs = extra.buildInputs ++ previousAttrs.buildInputs;
    }
    // lib.optionalAttrs (previousAttrs ? cargoDeps) {
      cargoDeps = prev.rustPlatform.importCargoLock cargoLock;
      cargoHash = null;
    }
    // replace' previousAttrs
  )
)
