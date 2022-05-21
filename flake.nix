{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    # nixpkgs-nov21.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;

    # home-manager = {
    #   url = "github:nix-community/home-manager?rev=454abeb5a891b2b56f10a30f2a846e8341cbfe9b";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # home-manager-nov21 = {
    #   url = "github:nix-community/home-manager?rev=d93d56ab8c1c6aa575854a79b9d2f69d491db7d0";
    #   inputs.nixpkgs.follows = "nixpkgs-nov21";
    # };
    personal-pkgs.url = "github:harris-chris/personal-packages";
  };

  outputs = inputs @ {
    self
    , nixpkgs
    # , nixpkgs-nov21
    # , nixpkgs-unstable
    , home-manager
    # , home-manager-nov21
    , personal-pkgs
    , nixos-hardware
  }:
    let
      system = "x86_64-linux";
      # overlay-nov21 = final: prev: {
      #   nov21 = inputs.nixpkgs-nov21.legacyPackages.${system};
      # };
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
