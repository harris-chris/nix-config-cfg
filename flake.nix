{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    claude-nix.url = "github:harris-chris/claude-nix";
  };

  outputs = inputs @ {
    self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , claude-nix
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
          claude-nix.homeManagerModules.claude-code
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
