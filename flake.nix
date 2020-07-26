
{
  # TODO: rename git repo to 'flake-wayland-apps'
  description = "wayland-apps";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    cachixpkgs = { url = "github:nixos/nixpkgs/nixos-20.03"; };
  };

  outputs = inputs:
    let
      metadata = builtins.fromJSON (builtins.readFile ./latest.json);

      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      forAllSystems = genAttrs [ "x86_64-linux" "aarch64-linux" ];

      overlay = import ./default.nix;
      
      pkgsFor = pkgs: system: includeOverlay:
        import pkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = if includeOverlay then [ overlay ] else [];
        };
    in
    rec {
      devShell = forAllSystems (system:
        let
          nixpkgs_ = (pkgsFor inputs.nixpkgs system false);
          cachixpkgs_ = (pkgsFor inputs.cachixpkgs system false);
        in
          nixpkgs_.mkShell {
            nativeBuildInputs = with nixpkgs_; [
              cachixpkgs_.cachix
              nixFlakes
              bash cacert 
              curl git jq mercurial
              nix-build-uncached
              nix-prefetch openssh ripgrep
            ];
          }
      );

      overlay = final: prev:
        import ./default.nix final prev;

      # flakes-util candidate:
      # make it even more auto to determine sys from the attr name
      # I think it just needs a genAttrs actually
      packages = let
        pkgs = sys: 
          let
            nixpkgs_ = (pkgsFor inputs.nixpkgs sys true);
            packagePlatforms = pkg: pkg.meta.hydraPlatforms or pkg.meta.platforms or [ "x86_64-linux" ];
            pred = n: v: builtins.elem sys (packagePlatforms v);
          in
            nixpkgs_.lib.filterAttrs pred nixpkgs_.waylandPkgs; 
      in {
          x86_64-linux = pkgs "x86_64-linux";
          aarch64-linux = pkgs "aarch64-linux";
        };

      # TODO flake-util: join all `inputs.self.packages`
      # TODO: recursive dependencies aren't checked
      defaultPackage = forAllSystems (system:
        let
          nixpkgs_ = (pkgsFor inputs.nixpkgs system true);
          attrValues = inputs.nixpkgs.lib.attrValues;
          out = packages."${system}";
        in
          nixpkgs_.symlinkJoin {
            name = "nixpkgs-wayland";
            paths = attrValues out;
          }
      );

      hydraJobs = {
        packages = inputs.self.packages;
      };
    };
}

