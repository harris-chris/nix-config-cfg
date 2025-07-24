{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
  };

  outputs = inputs @ {
    self
    , nixpkgs
    , home-manager
    , nixos-hardware
  }:
  let
    system = "x86_64-linux";

    homeConfigurations = {
      chris = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ./lib/default.nix).overlay
          ];
          config.allowUnfree = true;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
      chris-server = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ./lib/default.nix).overlay
          ];
          config.allowUnfree = true;
        };
        modules = [
          ./home-manager/home-server.nix
        ];
      };
    };
  in
    {
      inherit homeConfigurations;
      nixosConfigurations = (
        import ./system.nix {
          inherit (nixpkgs) lib;
          inherit inputs system nixos-hardware;
        }
      );
    };
}
