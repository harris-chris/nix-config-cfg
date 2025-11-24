{ config, pkgs, lib, ... }:

let
in
{
  home = rec {
    packages = with pkgs; [ ];
  };
  programs.helix = {
    languages = {
      language = [
        {
          name = "haskell";
          indent = {
            tab-width = 2;
            unit = " ";
          };
        }
        {
          name = "rust";
          indent = {
            tab-width = 2;
            unit = " ";
          };
        }
      ];
    };
    settings = {
      theme = "dracula_at_night";
      editor = {
        smart-tab.enable = false;
      };
      keys.normal = {
        space.o = "jumplist_picker";
        space.u = "hover";
        space.h = "jump_view_left";
        space.j = "jump_view_down";
        space.k = "jump_view_up";
        space.l = "jump_view_right";
        space.m = ":sh echo -n %{buffer_name} | wl-copy";  # Copy absolute path to clipboard
      };
    };
    enable = true;
  };
}

