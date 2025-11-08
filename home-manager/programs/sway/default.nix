{ pkgs, lib, ...}:

{
  services.mako = import ./mako.nix;
  home.packages = with pkgs; [
    foot
    fuzzel
    mako
    wl-clipboard
  ];
  wayland.windowManager.sway = rec {
    enable = true;
    wrapperFeatures.gtk = true ;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      defaultWorkspace = "1";
      keybindings = let
          modifier = config.modifier;
          ws1 = "y";
          ws2 = "u";
          ws3 = "i";
          ws4 = "o";
          ws5 = "p";
          ws6 = "grave";
        in lib.mkOptionDefault {
          "${modifier}+space" = lib.mkForce "exec ${config.terminal}";
          "${modifier}+d" = "exec bemenu-run";
          "${modifier}+v" = "kill";
          "${modifier}+x" = "kill";
          "${modifier}+${ws1}" = "workspace number 1";
          "${modifier}+Shift+${ws1}" = "move container to workspace number 1";
          "${modifier}+${ws2}" = "workspace number 2";
          "${modifier}+Shift+${ws2}" = "move container to workspace number 2";
          "${modifier}+${ws3}" = "workspace number 3";
          "${modifier}+Shift+${ws3}" = "move container to workspace number 3";
          "${modifier}+${ws4}" = "workspace number 4";
          "${modifier}+Shift+${ws4}" = "move container to workspace number 4";
          "${modifier}+${ws5}" = "workspace number 5";
          "${modifier}+Shift+${ws5}" = "move container to workspace number 5";
          "${modifier}+${ws6}" = "workspace number 6";
          "${modifier}+Shift+${ws6}" = "move container to workspace number 6";
        };

        bars = [
          (import ./swaybar.nix { inherit pkgs; })
        ];
    };
    extraConfig = ''
        input type:touchpad {
          tap enabled
        }
        input 1149:32980:SlimBlade_Pro {
          scroll_factor 2.0
        }
    '';
  };
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 60*30; command = "systemctl suspend"; }
    ];
  };
}
