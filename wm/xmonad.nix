{ config, lib, pkgs, ... }:

{

   programs.seahorse.enable = false;
   services = {
      gnome.gnome-keyring.enable = true;
      upower.enable = true;
      
      xserver = {
         enable = true;
         displayManager = {
                  defaultSession = "none+xmonad";
         };
         windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
         };
         xkbOptions = "caps:ctrl_modifier";
      };
   };

   hardware.bluetooth.enable = true;
   services.blueman.enable = true;
  
   systemd.services.upower.enable = true;
}
