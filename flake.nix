{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    personal-pkgs = {
      url = "github:harris-chris/personal-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self
    , nixpkgs
    , home-manager
    , personal-pkgs
    , nixos-hardware
  }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = (
        import ./home-manager.nix {
          inherit system nixpkgs home-manager personal-pkgs;
        }
      );

      nixosConfigurations = (
        import ./system.nix {
          inherit (nixpkgs) lib;
          inherit inputs system nixos-hardware;
        }
      );
    };
}
