{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    get-workspace-name.url = github:harris-chris/get-workspace-name;
    kakoune-workspace.url = github:harris-chris/kakoune-workspace;
  };

  outputs = inputs @ {
    self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , get-workspace-name
    , kakoune-workspace
  }:
  let
    system = "x86_64-linux";

    homeConfigurations = {
      chris = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            get-workspace-name.overlays.default
            kakoune-workspace.overlays.default
          ];
          config.allowUnfree = true;
        };
        modules = [
          ./home-manager/home.nix
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
