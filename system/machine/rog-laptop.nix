{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
   
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = [ "optimus_prime" ];


  fileSystems."/data" = {
     device = "/dev/disk/by-label/data";
     fsType = "ext4";
  };
}
