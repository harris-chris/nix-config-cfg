{ pkgs, ... }:

{
  programs.rofi.pass = {
    enable = true;
    stores = [
      "/data/gpg"
    ];
    extraConfig = ''
      EDITOR='v'
    '';
  };
}

