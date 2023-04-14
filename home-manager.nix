{ system, nixpkgs, home-manager, personal-pkgs }:

let

  personal-overlay = personal-pkgs.overlays.${system};

  username = "chris";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.xdg.configHome = configHome;
    overlays = [ personal-overlay ];
  };

  home = rec {
      stateVersion = "21.05";
      inherit username homeDirectory;
    };


  # edpConf = import ./home-manager/display/edp.nix {
  #   inherit pkgs;
  #   inherit (pkgs) config lib stdenv;
  # };
in
{
  edpHome = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home-manager/home.nix
        { inherit home; }
        (import ./home-manager/programs/alacritty/default.nix { fontSize = 8; inherit pkgs; })
      ];
    };
}
