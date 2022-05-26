{ pkgs, config, ... }:

let
  popupcommands = pkgs.callPackage ./scripts/popupcommands.nix { inherit config pkgs; };
  popupcommands_confirm = pkgs.callPackage ./scripts/popupcommands_confirm.nix { inherit config pkgs; };

  defaultPkgs = with pkgs; [
    any-nix-shell
    arandr
    awscli2
    bolt
    docker
    docker-compose
    diff-so-fancy
    exa
    fd
    gcc
    git-crypt
    gnumake
    jq
    kakoune-workspace
    killall
    libnotify
    lsof
    maim
    multilockscreen
    nano
    ncpamixer
    niv
    nix-index
    nix-prefetch-scripts
    nmap
    nnn
    pass
    p7zip
    popupcommands
    popupcommands_confirm
    ripgrep
    rnix-lsp
    signal-desktop
    spotify
    surf
    sway-contrib.grimshot
    tree
    which
    wmctrl
    xclip
  ];

  lsps = with pkgs; [
    ccls
    #hls
    #metals
    rust-analyzer
  ];

  # polybarPkgs = with pkgs; [
  #   font-awesome      # awesome fonts
  #   material-design-icons # fonts with glyphs
  # ];

  scripts = pkgs.callPackage ./scripts/default.nix { inherit config pkgs; };

  # xmonadPkgs = with pkgs; [
  #   nitrogen
  #   xcape
  #   xorg.xev
  #   xorg.xkbcomp
  #   xorg.xmodmap
  #   xorg.xrandr
  # ];

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

  # services.dunst = {
  #   enable = true;
  #   iconTheme = {
  #     name = "Adwaita";
  #     package = pkgs.gnome3.adwaita-icon-theme;
  #     size = "16x16";
  #   };
  #   settings = {
  #     global = {
  #       monitor = 0;
  #       geometry = "600x50-50+65";
  #       shrink = "yes";
  #       transparency = 10;
  #       padding = 16;
  #       horizontal_padding = 16;
  #       font = "JetBrainsMono Nerd Font 8";
  #       line_height = 4;
  #       format = ''<b>%s</b>\n%b'';
  #     };
  #   };
  # };

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
      settings.sort_key = "PERCENT_CPU";
    };

    ssh.enable = true;
  };

  imports = imports;
}
