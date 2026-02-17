{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # fileSystems."/data" = {
  #   device = "/dev/disk/by-label/data";
  #   fsType = "ext4";
  # };

  systemd.services.system76-charge-thresholds = {
    description = "Set System76 charge thresholds to balanced";
    after = [ "system76-power.service" ];
    requires = [ "system76-power.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.system76-power}/bin/system76-power charge-thresholds --profile balanced";
      RemainAfterExit = true;
    };
  };
}
