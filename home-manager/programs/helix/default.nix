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
      keys.normal = {
        space.o = "jumplist_picker";
        space.u = "hover";
        space.h = "jump_view_left";
        space.j = "jump_view_down";
        space.k = "jump_view_up";
        space.l = "jump_view_right";
        space.m = [":sh echo -n $(realpath %) | xclip -selection clipboard"];  # Copy absolute path to clipboard
      };
    };
    enable = true;
  };
}

