{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    home-manager = {
      url = "github:nix-community/home-manager?rev=454abeb5a891b2b56f10a30f2a846e8341cbfe9b";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    personal-pkgs.url = "github:harris-chris/personal-packages";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, personal-pkgs }:
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
          inherit inputs system;
        }
      );
    };
}
