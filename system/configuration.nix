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
  imports = [];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.extraHosts = ''
    10.21.5.20 metis
    10.21.5.30 aether
    172.16.20.6 hermes
    172.16.20.7 fastbox2
    172.16.20.8 anemoi
    172.16.20.9 apollo
    172.16.20.10 fastbox1
    172.16.20.11 turbobox
    172.16.20.13 rocketman
    172.16.20.16 achilles
    172.16.20.17 atlas
    172.16.20.21 nixbuildserver
    172.16.20.25 hades
    172.16.20.58 git.lan.raptortt.com
    172.16.20.58 hg.lan.raptortt.com
    172.16.20.59 buildserver
  '';

  time.timeZone = "Asia/Tokyo";

  services = {
    blueman.enable = true;
    dbus.enable = true;
    pipewire.enable = true;
    power-profiles-daemon.enable = false;
    tailscale.enable = true;
    tlp.enable = true;
    udev.packages = [ pkgs.via ];
  };

  xdg.portal.wlr.enable = true;

  nix.nixPath = [
    "nixos-config=/cfg/configuration.nix"
    "nixpkgs=https://github.com/NixOS/nixpkgs/archive/23.11.tar.gz"
  ];
  nix.package = pkgs.nixUnstable;
  nix.settings = {
    trusted-users = [ "root" "chris" ];
    system-features = [ "raptor" "big-parallel" ];
    # For xilinx vivado
    extra-sandbox-paths = [ "/opt" ];
    # Binary Cache for Haskell.nix
    substituters = [ "https://cache.iog.io" ];
    trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    builders-use-substitutes = true
    cores = 8
    allow-import-from-derivation = true
  '';
  nix.buildMachines = [ {
    hostName = "builder@172.16.20.21";
    system = "x86_64-linux";
    maxJobs = 4;
    speedFactor = 2;
    supportedFeatures = [ ];
    mandatoryFeatures = [ "raptor" ];
  }] ;
  nix.distributedBuilds = true;

  sound.enable = true;
  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
    opengl = {
      enable = true;
      extraPackages = [ pkgs.vaapiIntel ];
    };
    pulseaudio.enable = true;
  };

  fonts.packages = with pkgs; [
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

  # i18n.inputMethod.enabled = "fcitx";
  # i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];

  virtualisation.docker.enable = true;

  programs = {
    fish.enable = true;
    steam.enable = true;
  };

  security.wrappers = {
    termshark = {
      source = "${pkgs.termshark}/bin/termshark";
      capabilities = "cap_net_raw,cap_net_admin+eip";
      permissions = "u+rx,g+x";
      owner = "root";
      group = "wireshark";
    };
    dumpcap = {
      source = "${pkgs.wireshark-cli}/bin/dumpcap";
      capabilities = "cap_net_raw,cap_net_admin+eip";
      permissions = "u+rx,g+x";
      owner = "root";
      group = "wireshark";
    };
    tcpdump = {
      source = "${pkgs.tcpdump}/bin/tcpdump";
      capabilities = "cap_net_raw,cap_net_admin+eip";
      permissions = "u+rx,g+x";
      owner = "root";
      group = "wireshark";
    };
  };

  users = {
    groups.wireshark = {};
    users = {
      chris = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "plugdev" "netdev" "networkmanager" "wireshark" ];
        shell = pkgs.fish;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      git
      openfortivpn
      kakoune
      termshark
      via
      wget
      wireshark-cli
      vim
    ];
    variables = {
      XDG_CURRENT_DESKTOP = "sway";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "20.09";

}

