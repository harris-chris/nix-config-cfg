{ config, pkgs, lib, ... }:

let
in
{
  home = rec {
    packages = with pkgs; [ ];
  };
  programs.helix = {
    settings = {
      theme = "dracula_at_night";
    };
    enable = true;
  };
}

