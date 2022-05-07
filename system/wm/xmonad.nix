{ config, lib, pkgs, ... }:
let
  customModMap = pkgs.writeText "xkb-layout" ''
    remove Lock = Caps_Lock
    remove Control = Control_L
    remove Lock = Control_L
    remove Control = Caps_Lock
    keysym Control_L = Caps_Lock
    keysym Caps_Lock = Control_L
    add Lock = Caps_Lock
    add Control = Control_L
  '';
in {
  programs.seahorse.enable = false;
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    xserver = {
      enable = true;
      
      libinput = {
        enable = true;
        touchpad.disableWhileTyping = true;
      };

      displayManager.defaultSession = "none+xmonad";

      windowManager.xmonad = {
         enable = true;
         enableContribAndExtras = true;
      };
      xkbOptions = "ctrl:nocaps";
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
 
  systemd.services.upower.enable = true;
}
