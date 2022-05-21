{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # fileSystems."/data" = {
  #   device = "/dev/disk/by-label/data";
  #   fsType = "ext4";
  # };
}
