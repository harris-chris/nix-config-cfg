{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    personal_pkgs.url = "github:harris-chris/personal-packages";
    get_workspace_name.url = github:harris-chris/get-workspace-name;
    kakoune_workspace.url = github:harris-chris/kakoune-workspace;
  };

  outputs = inputs @ {
    self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , personal_pkgs
    , get_workspace_name
    , kakoune_workspace
  }:
  let
    system = "x86_64-linux";

    homeConfigurations = {
      chris = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            personal_pkgs.overlays.default
            get_workspace_name.overlays.default
            kakoune_workspace.overlays.default
            (import ./lib/default.nix).overlay
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
