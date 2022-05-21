{ config, lib, pkgs, ... }:

let
  customFonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "Iosevka"
    ];
  };
  myfonts = pkgs.callPackage fonts/default.nix { inherit pkgs; };
  udevRules = pkgs.callPackage ./udev/default.nix { inherit pkgs; };

in {
  imports =
    [ # Include the results of the hardware scan.
      # ./wm/xmonad.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.extraHosts = ''
    172.16.20.17 atlas
    172.16.20.16 achilles
    172.16.20.10 fastbox1
    172.16.20.9 apollo
    172.16.20.8 anemoi
    172.16.20.6 hermes
  '';

  time.timeZone = "Asia/Tokyo";

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  # Enable the X11 windowing system.
  #services.xserver = {
    #enable = true;
    #displayManager.gdm.enable = true;
    #desktopManager.gnome.enable = true;
    ##xkbOptions = "ctrl:nocaps";
    ##displayManager.sessionCommands = ''
      ##${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      ##Xft.dpi: 60
    ##EOF
    ##'';
  #};

  # Binary Cache for Haskell.nix
  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.binaryCaches = [
    "https://hydra.iohk.io"
  ];
  nix.nixPath = [
    "nixos-config=/cfg/configuration.nix"
    "nixpkgs=https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz"
  ];

  # For xilinx vivado
  nix.sandboxPaths = ["/opt"];

  # Enable flakes
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.udev.packages = [ udevRules ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.vaapiIntel ];
  };
  #environment.variables = {
    #MESA_GL_VERSION_OVERRIDE = "2.1";
  #};

  fonts.fonts = with pkgs; [
    customFonts
    dejavu_fonts
    font-awesome
    myfonts.icomoon-feather
    ipafont
    kochi-substitute
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "JetBrainsMono"
      "IPAGothic"
    ];
    sansSerif = [
      "Ioveska"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  i18n.inputMethod.enabled = "fcitx";
  i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];

  virtualisation.docker.enable = true;

  # programs.sway = {
  #   enable = true;
  #   # wrapperFeatures.gtk = true;
  #   extraPackages = with pkgs; [
  #     foot # Alacritty is the default terminal in the config
  #   ];
  # };
  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.chris = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
    };

  environment.systemPackages = with pkgs; [
    wget vim
    openfortivpn
    nixops
    kakoune
    git
  ];

  nixpkgs.config.allowUnfree = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "20.09";

}

