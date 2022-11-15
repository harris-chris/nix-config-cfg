{ pkgs, config, ... }:

let
  popupcommands = pkgs.callPackage ./scripts/popupcommands.nix {
    inherit config pkgs;
  };
  popupcommands_confirm = pkgs.callPackage ./scripts/popupcommands_confirm.nix {
    inherit config pkgs;
  };

  defaultPkgs = with pkgs; [
    atop
    any-nix-shell
    awscli2
    bemenu
    bolt
    docker
    docker-compose
    diff-so-fancy
    exa
    fd
    gcc
    gdu
    git-crypt
    jq
    kakoune-workspace
    libnotify
    lsof
    ncpamixer
    nix-index
    nix-prefetch-scripts
    nmap
    nnn
    pass
    p7zip
    popupcommands
    popupcommands_confirm
    prettyping
    ripgrep
    rnix-lsp
    signal-desktop
    spotify
    sway-contrib.grimshot
    tree
    usbutils
    which
    xdg-utils
  ];

  lsps = with pkgs; [
    # ccls
    #hls
    #metals
    # rust-analyzer
  ];

  scripts = pkgs.callPackage ./scripts/default.nix { inherit config pkgs; };

  importedPrograms = import ./programs;
  importedServices = import ./services;
  importedXdg = import ./xdg;
  imports = importedPrograms ++ importedServices ++ importedXdg;

in {
  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = p: {
      fish-foreign-env = pkgs.fishPlugins.foreign-env;
    };
  };

  home = {
    username = "chris";
    homeDirectory = "/home/chris";
    packages = defaultPkgs ++ lsps ++ scripts; # ++ personalPkgs;
    stateVersion = "21.05";

    sessionVariables = {
      # DISPLAY = ":0";
      EDITOR = "kk";
      # JULIA_DEPOT_PATH = "/home/chris/.julia";
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

    ssh.enable = true;
  };

  imports = imports;
}
