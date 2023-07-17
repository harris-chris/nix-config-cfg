{ pkgs, config, ... }:

let

  defaultPkgs = with pkgs; [
    atop
    any-nix-shell
    awscli2
    bemenu
    bolt
    docker
    diff-so-fancy
    exa
    fd
    firefox
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
    prettyping
    ripgrep
    rnix-lsp
    signal-desktop
    spotify
    swappy
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

  importedPrograms = import ./programs;
  importedServices = import ./services;
  importedXdg = import ./xdg;
  imports = importedPrograms ++ importedServices ++ importedXdg;

in {
  inherit imports;
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
    packages = defaultPkgs ++ lsps; # ++ personalPkgs;
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

}
