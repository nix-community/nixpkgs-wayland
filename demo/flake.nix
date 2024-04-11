{
  description = "nixpkgs-wayland";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    lib-aggregate = {
      url = "github:nix-community/lib-aggregate";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://nixpkgs-wayland.cachix.org" ];
    extra-trusted-public-keys = [
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  outputs =
    inputs:
    let
      inherit (inputs.lib-aggregate) lib;
      inherit (inputs) self;
    in
    lib.flake-utils.eachSystem
      [
        "aarch64-linux"
        "x86_64-linux"
        "riscv64-linux"
      ]
      (system: {
        nixosConfigurations.demo = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./configuration.nix
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlays.default ];
              }
            )

            (
              { pkgs, modulesPath, ... }:
              {
                imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];
                virtualisation = {
                  memorySize = 1024 * 8;
                  diskSize = 1024 * 2;
                  cores = 8;
                };
                # For running Sway in a QEMU VM the Arch Linux Wiki recommends to use
                # the QXL virtualized graphics card:
                # https://wiki.archlinux.org/title/sway#Virtualization
                # The screen resolution isn't automatically scaled. Full HD seems to
                # be a good default that should work on most systems well.
                virtualisation.qemu.options = [ "-device qxl-vga,xres=1920,yres=1080" ];

                # The Arch Linux Wiki suggests using the qxl and bochs_drm kernel
                # modules:
                # https://wiki.archlinux.org/title/QEMU#qxl
                boot.kernelModules = [
                  "qxl"
                  "bochs_drm"
                ];
              }
            )
          ];
        };
        packages = {
          demo-vm = self.nixosConfigurations.${system}.demo.config.system.build.vmWithBootLoader;
        };
      });
}
