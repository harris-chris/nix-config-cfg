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
    eza
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
    signal-desktop
    sioyek
    spotify
    swappy
    sway-contrib.grimshot
    tree
    usbutils
    which
    xdg-utils
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
    packages = defaultPkgs;
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
      matchBlocks = {
        "git.lan.raptortt.com" = {
          port = 222;
          user = "charris";
          identityFile = "~/.ssh/raptor_git";
        };
        "github-raptor" = {
          user = "git";
          hostname = "github.com";
          identityFile = "~/.ssh/raptor_github";
          identitiesOnly = true;
        };
      };
    };
  };
}
