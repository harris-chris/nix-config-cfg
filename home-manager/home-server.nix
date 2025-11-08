{ pkgs, config, ... }:

let

  serverPkgs = with pkgs; [
    atop
    any-nix-shell
    diff-so-fancy
    eza
    fd
    gdu
    git-crypt
    jq
    lsof
    nix-index
    nix-prefetch-scripts
    nmap
    nnn
    p7zip
    prettyping
    ripgrep
    tree
    usbutils
    which
  ];

  importedPrograms = import ./server-programs;
  importedServices = import ./server-services;
  imports = importedPrograms ++ importedServices;

in {
  inherit imports;
  programs.home-manager.enable = true;
  
  home.enableNixpkgsReleaseCheck = false;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = p: {
      fish-foreign-env = pkgs.fishPlugins.foreign-env;
    };
  };

  home = {
    username = "chris";
    homeDirectory = "/home/chris";
    packages = serverPkgs;
    stateVersion = "21.05";

    sessionVariables = {
      EDITOR = "hx";
    };
    keyboard = null;
  };

  programs = {
    bat.enable = true;
    gpg.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    htop = {
      enable = true;
      settings.sort_key = "PERCENT_MEM";
    };

    ssh = {
      enable = true;
    };
  };
}
