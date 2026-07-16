{ config, pkgs, lib, ... }:

let
  clipboard-copy = pkgs.writeShellScript "clipboard-copy" ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      ${pkgs.wl-clipboard}/bin/wl-copy "$@"
    elif [ -n "$DISPLAY" ]; then
      ${pkgs.xclip}/bin/xclip -selection clipboard "$@"
    else
      # No display (e.g. over SSH): hand stdin to the terminal itself via OSC 52.
      printf '\033]52;c;%s\a' "$(${pkgs.coreutils}/bin/base64 -w0)" > /dev/tty
    fi
  '';
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
        space.m = ":sh echo -n %{buffer_name} | ${clipboard-copy}";  # Copy absolute path to clipboard
      };
    };
    enable = true;
  };
}

