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
      ./hardware-configuration.nix
      ./machine/current.nix
      ./wm/xmonad.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;

  # Set your time zone.
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
    font-awesome-ttf
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

  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.chris = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
    };

  # programs.steam.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim
    openfortivpn
    nixops
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

