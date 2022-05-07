{ system, nixpkgs, home-manager, personal-pkgs }:

let
  username = "chris";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
  personal-overlay = personal-pkgs.overlays.${system};

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.xdg.configHome = configHome;
    overlays = [ personal-overlay ];
  };

in
{
  chris = home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs system username homeDirectory;

    stateVersion = "21.05";
    configuration = import ./home-manager/home.nix {
      inherit pkgs;
      inherit (pkgs) config lib stdenv;
    };
  };
}
